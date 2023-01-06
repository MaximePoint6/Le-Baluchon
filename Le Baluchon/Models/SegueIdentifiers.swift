//
//  SegueIdentifiers.swift
//  Le Baluchon
//
//  Created by Maxime Point on 28/12/2022.
//

import Foundation

enum SegueIdentifiers: String {
    case segueFromOnBoardingToSearchCity
    case segueToWeatherView
    case segueToSettingsView
    case segueToSearchCity
    case segueToSearchLanguage
    
    
    /// Function to compare a String and an SegueIdentifiers
    /// - Returns: returns a boolean if the two parameters are equal
    static func == (lhs: String?, rhs: SegueIdentifiers) -> Bool {
        lhs == rhs.rawValue
    }
}
