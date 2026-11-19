//
//  SavedCodeViewModel.swift
//  SimpleQRCodeGenerator
//
//  Created by Sebastian Fox on 04.01.25.
//

import Foundation
import SwiftData

class SavedCodeViewModel: ObservableObject {
    var modelContext: ModelContext
    
    @Published var savedCodes = [SavedCode]()
    
    func fetchData() {
        do {
            var descriptor = FetchDescriptor<SavedCode>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
            descriptor.fetchLimit = 100
            savedCodes = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
    }
    
    func addSavedCode(_ savedCode: SavedCode) {
        modelContext.insert(savedCode)
        fetchData()
    }
    
    func addNewSavedCode(_ timestamp: Date, _ textToEncode: String, _ format: String) {
        let newSavedCode = SavedCode(timestamp: timestamp, textToEncode: textToEncode, format: format)
        modelContext.insert(newSavedCode)
        fetchData()
    }
    
    func deleteSavedCode(_ savedCode: SavedCode) {
        modelContext.delete(savedCode)
        fetchData()
    }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchData()
    }
}
