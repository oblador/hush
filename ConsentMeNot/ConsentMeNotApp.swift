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
    init() {
        print("lol init.")
        let identifier = "\(Bundle.main.bundleIdentifier ?? "se.oblador.ConsentMeNot").ContentBlocker"
        print(identifier)
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: identifier,
            completionHandler: { (error) in
                if (error != nil) {
                    print("sad boi")
                    print(error)
                }
//                print ("SFContentBlockerManager.reloadContentBlockerWithIdentifier")
//                print (error)
//                print (error?.localizedDescription)
        })
//        SFContentBlockerManager.reloadContentBlocker(withIdentifier: <#T##String#>, completionHandler: <#T##((Error?) -> Void)?##((Error?) -> Void)?##(Error?) -> Void#>)
    }

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
