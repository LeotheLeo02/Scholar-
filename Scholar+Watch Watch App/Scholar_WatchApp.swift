//
//  Scholar_WatchApp.swift
//  Scholar+Watch Watch App
//
//  Created by Nate on 9/22/22.
//

import SwiftUI

struct Scholar_Watch_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)

        }
    }
}
