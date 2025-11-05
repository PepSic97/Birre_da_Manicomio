//
//  BirreDaManicomioApp.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 05/11/25.
//

import SwiftUI
import CoreData

@main
struct BirreDaManicomioApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
