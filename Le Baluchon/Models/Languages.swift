//
//  Lang.swift
//  Le Baluchon
//
//  Created by Maxime Point on 25/11/2022.
//

import Foundation

enum Languages: String, CaseIterable, Codable {
    case en
    case fr
    
    /// Returns the language name
    var description: String {
        switch self {
            case .en: return "English"
            case .fr: return "Français"
        }
    }
}
