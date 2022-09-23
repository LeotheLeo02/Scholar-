//
//  Scholar_App.swift
//  Scholar+
//
//  Created by Nate on 9/22/22.
//

import SwiftUI

@main
struct Scholar_App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
