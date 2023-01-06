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
        guard self.translations.count > 0, let result = self.translations[0].text else {
            return "-"
        }
        return result
    }
    
    static var availableLanguages = [
        "BG",
        "CS",
        "DA",
        "DE",
        "EL",
        "EN",
        "ES",
        "ET",
        "FI",
        "FR",
        "HU",
        "ID",
        "IT",
        "JA",
        "LT",
        "LV",
        "NL",
        "PL",
        "PT",
        "RO",
        "RU",
        "SK",
        "SL",
        "SV",
        "TR",
        "UK",
        "ZH"
    ]
}
