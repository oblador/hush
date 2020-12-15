//
//  ConsentMeNotApp.swift
//  ConsentMeNot
//
//  Created by Joel Arvidsson on 2020-12-11.
//

import SwiftUI
import SafariServices

@main
struct ConsentMeNotApp: App {
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared
    let contentBlockerIdentifier = "\(Bundle.main.bundleIdentifier ?? "se.oblador.Hush").ContentBlocker"
    let appState = AppState()

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
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(appState)
                .onAppear(perform: refreshEnabledState)
                .onChange(of: scenePhase, perform: { phase in
                    if (phase == .active) {
                        refreshEnabledState()
                    }
                })
        }
    }
}
