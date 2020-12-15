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
    let persistenceController = PersistenceController.shared
//    var contentBlockerIsEnabled : Bool
//    var reloadErrorDesc: String? = nil

    init() {
        print("lol init.")
        let identifier = "\(Bundle.main.bundleIdentifier ?? "se.oblador.ConsentMeNot").ContentBlocker"
        print(identifier)
//        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: identifier, completionHandler: { (state, error) in
//            if let error = error {
//                print(error)
//            }
//            if let state = state {
//                contentBlockerIsEnabled = state.isEnabled
//                // TODO: do something with this value
//            }
//        })

        SFContentBlockerManager.reloadContentBlocker(withIdentifier: identifier,
            completionHandler: { (error) in
                if (error != nil) {
                    print("sad boi")
                    print(error)
//                    reloadErrorDesc = error.debugDescription
//                    let alert = Alert(title: Text("Big sad"), message: Text("Error: \(error.debugDescription ?? "No error")"), dismissButton: .default(Text("okidoki")))
                } else {
                    print("yay")
                }
//                print ("SFContentBlockerManager.reloadContentBlockerWithIdentifier")
//                print (error)
//                print (error?.localizedDescription)
        })
//        SFContentBlockerManager.reloadContentBlocker(withIdentifier: <#T##String#>, completionHandler: <#T##((Error?) -> Void)?##((Error?) -> Void)?##(Error?) -> Void#>)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
