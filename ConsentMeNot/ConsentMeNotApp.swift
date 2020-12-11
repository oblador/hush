//
//  ConsentMeNotApp.swift
//  ConsentMeNot
//
//  Created by Joel Arvidsson on 2020-12-11.
//

import SwiftUI

@main
struct ConsentMeNotApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
