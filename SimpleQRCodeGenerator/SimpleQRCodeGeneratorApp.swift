//
//  SimpleQRCodeGeneratorApp.swift
//  SimpleQRCodeGenerator
//
//  Created by Sebastian Fox on 05.10.22.
//

import SwiftUI
import SwiftData

@main
struct SimpleQRCodeGeneratorApp: App {
    var savedCodeViewModel: SavedCodeViewModel
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SavedCode.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        self.savedCodeViewModel = SavedCodeViewModel(modelContext: sharedModelContainer.mainContext)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(savedCodeViewModel)
        }
        .modelContainer(sharedModelContainer)
    }
}
