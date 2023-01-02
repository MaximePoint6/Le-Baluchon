//
//  Translation.swift
//  Le Baluchon
//
//  Created by Maxime Point on 02/01/2023.
//

import Foundation

struct Translation: Codable {
    var translations: [TransalationDetails]
    
    struct TransalationDetails: Codable {
        var detectedSourceLanguage: String?
        var text: String?
    }
    
    // MARK: Tools for ViewControllers
    var resultText: String {
        guard let result = self.translations[0].text else {
            return "-"
        }
        return result
    }
}
