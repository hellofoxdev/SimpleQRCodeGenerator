//
//  SavedCode.swift
//  SimpleQRCodeGenerator
//
//  Created by Sebastian Fox on 04.01.25.
//

import Foundation
import SwiftData

@Model
final class SavedCode {
    var timestamp: Date
    var textToEncode: String
    var format: String
    
    init(timestamp: Date, textToEncode: String, format: String) {
        self.timestamp = timestamp
        self.textToEncode = textToEncode
        self.format = format
    }
}
