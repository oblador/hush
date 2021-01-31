import Foundation
import BackgroundTasks
import SafariServices

class BlockListManager {
    var backgroundRefreshObserver: NSKeyValueObservation?
    #if os(macOS)
    var activityScheduler: NSBackgroundActivityScheduler?
    #endif
    static let urlSession = URLSession(configuration: .default)

    init() {
        registerBackgroundRefreshTask()
        backgroundRefreshObserver = UserDefaults.standard.observe(\.backgroundRefreshEnabled, options: [.initial, .new], changeHandler: { [weak self] (defaults, change) in
            print("backgroundRefreshEnabled: \(defaults.backgroundRefreshEnabled)")
            
            guard let strongSelf = self else { return }
            if (defaults.backgroundRefreshEnabled) {
                strongSelf.fetchRules()
                strongSelf.scheduleRefresh()
            } else {
                strongSelf.cancelRefresh()
            }
        })
    }
    
    deinit {
        backgroundRefreshObserver?.invalidate()
    }

    func registerBackgroundRefreshTask() -> Void {
        #if os(macOS)
        activityScheduler = NSBackgroundActivityScheduler(identifier: Config.fetchRulesTaskIdentifier)
        #else
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: Config.fetchRulesTaskIdentifier,
            using: nil) { (task) in
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
        #endif
    }
    
    func scheduleRefresh(interval: TimeInterval = 24 * 60 * 60) {
        #if os(macOS)
        activityScheduler!.invalidate()
        activityScheduler!.repeats = true
        activityScheduler!.interval = interval
        activityScheduler!.schedule() { [weak self] (completion: @escaping NSBackgroundActivityScheduler.CompletionHandler) in
            guard let strongSelf = self else { return }
            strongSelf.fetchRules { (error) in
                completion(NSBackgroundActivityScheduler.Result.finished)
            }
        }
        #else
        let request = BGAppRefreshTaskRequest(identifier: Config.fetchRulesTaskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: interval)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
        #endif
    }

    func cancelRefresh() {
        #if os(macOS)
        activityScheduler!.invalidate()
        #else
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: Config.fetchRulesTaskIdentifier)
        #endif
    }
    
    #if os(iOS)
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        task.expirationHandler = {
            BlockListManager.urlSession.invalidateAndCancel()
            task.setTaskCompleted(success: false)
        }
        fetchRules { (error) in
            task.setTaskCompleted(success: error == nil)
        }
        scheduleRefresh()
    }
    #endif

    func reloadContentBlocker(completionHandler: ((Error?) -> Void)? = nil) {
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: Config.contentBlockerIdentifier,
                                                     completionHandler: completionHandler)
    }
    
    func fetchRules(completionHandler: ((Error?)-> Void)? = nil) {
        if let url = URL(string: Config.blockListDownloadURL) {
            BlockListManager.urlSession.dataTask(with: url) { [self] data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
                        if let data = data {
                            let documentsDirectory = FileManager().containerURL(forSecurityApplicationGroupIdentifier: Config.appGroupIdentifier)
                            let archiveURL = documentsDirectory?.appendingPathComponent("blockerList.json")
                            do {
                                try data.write(to: archiveURL!)
                                print("Wrote block list to \(archiveURL!.path)")
                                return reloadContentBlocker(completionHandler: { (error) in
                                    if let error = error {
                                        print("Failed to reload content blocker")
                                        print(error)
                                    } else {
                                        print("Successfully reloaded content blocker")
                                        UserDefaults.standard.set(Int(Date().timeIntervalSince1970), forKey: "rulesLastRefreshedAt")
                                    }
                                    completionHandler?(error)
                                })
                            } catch {
                                print("Failed to write to \(archiveURL?.absoluteString ?? "nil")")
                            }
                        }
                    } else {
                        print("Fetch failed with status code \(httpResponse.statusCode)")
                    }
                }
                completionHandler?(error)
            }.resume()
        }

    }
    
    func fetchEnabledState(completionHandler: @escaping (SFContentBlockerState?, Error?) -> Void) {
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: Config.contentBlockerIdentifier, completionHandler:completionHandler)
    }
}
