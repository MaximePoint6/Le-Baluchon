//
//  TemperatureUnitPreference.swift
//  Le Baluchon
//
//  Created by Maxime Point on 30/11/2022.
//

import Foundation

enum TemperatureUnit: String, CaseIterable, Codable {
    case Kelvin
    case Celsius
    case Fahrenheit
    
    /// Returns the temperature unit symbol.
    var unit: String {
        switch self {
            case .Kelvin: return "K"
            case .Celsius: return "°C"
            case .Fahrenheit: return "°F"
        }
    }
}
