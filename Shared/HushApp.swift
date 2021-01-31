import SwiftUI
import SafariServices

@main
struct HushApp: App {
    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif

    let contentBlockerIdentifier = "\(Bundle.main.bundleIdentifier ?? "se.oblador.Hush").ContentBlocker"
    let appState = AppState(initialContentBlockerEnabledState: .undetermined)

    init() {
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: contentBlockerIdentifier,
            completionHandler: { (error) in
                if let error = error {
                    print("Failed to reload content blocker")
                    print(error)
                }
        })
    }

    func refreshEnabledState() {
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: contentBlockerIdentifier, completionHandler: { (state, error) in
            if let error = error {
                print("Failed to get content blocker state")
                print(error)
                DispatchQueue.main.async {
                    appState.contentBlockerEnabledState = .undetermined
                }
            }
            if let state = state {
                DispatchQueue.main.async {
                    appState.contentBlockerEnabledState = state.isEnabled ? .enabled : .disabled
                }
            }
        })
    }

    var body: some Scene {
        #if os(macOS)
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .onAppear(perform: refreshEnabledState)
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willBecomeActiveNotification)) { _ in
                    refreshEnabledState()
                }
                .frame(
                    minWidth: 320,
                    idealWidth: 350,
                    maxWidth: 500,
                    minHeight: 440,
                    idealHeight: 460,
                    maxHeight: 600
                )
                .background(Color.appBackgroundColor.ignoresSafeArea())
        }
        .commands {
            // Disable "New Window" command
            CommandGroup(replacing: CommandGroupPlacement.newItem) {}
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        #else
        WindowGroup {
            ZStack {
                Color.appBackgroundColor.ignoresSafeArea()
                ContentView()
                    .environmentObject(appState)
                    .onAppear(perform: refreshEnabledState)
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                        refreshEnabledState()
                    }
            }
        }
        #endif
    }
}
