//
//  ExchangeRate.swift
//  Le Baluchon
//
//  Created by Maxime Point on 01/01/2023.
//

import Foundation

struct ExchangeRate: Codable {
    var date: String?
    var result: Double?
    var success: Bool?
    
    // MARK: Tools for ViewControllers
    var resultText: String {
        guard let result = self.result else {
            return "-"
        }
        let resultString = String(result)
        return resultString
    }
}
