//
//  City.swift
//  Le Baluchon
//
//  Created by Maxime Point on 25/11/2022.
//

import Foundation

struct City: Codable {

    var name: String?
    var localNames: LocalNames?
    var lat: Double?
    var lon: Double?
    var country: String?
    var state: String?
    var countryDetails: CountryDetails?

    struct CountryDetails: Codable {
        var name: String?
        var currencies: [Currencies]?
        var languages: [CountryLanguages]?
    }
    
    struct Currencies: Codable {
        var code: String?
        var name: String?
        var symbol: String?
    }
    
    struct CountryLanguages: Codable {
        var iso6391: String?
        var iso6392: String?
        var name: String?
        var nativeName: String?
    }

    struct LocalNames: Codable {
        var featureName: String?
        var ascii: String?
        var en: String?
        var fr: String?
    }
    
    // MARK: Tools for ViewControllers
    var stateAndCountryDetails: String {
        if let stateOfTheCity = self.state {
            if let countryOfTheCity = self.country {
                return "\(stateOfTheCity), \(countryOfTheCity)"
            } else {
                return stateOfTheCity
            }
        } else {
            if let countryOfTheCity = self.country {
                return countryOfTheCity
            } else {
                return ""
            }
        }
    }
    
    func getNameWithStateAndCountry(languageKeys: Languages) -> String {
        let localName = getLocalName(languageKeys: languageKeys)
        
        if let stateOfTheCity = self.state {
            if let countryOfTheCity = self.country {
                return "\(localName), \(stateOfTheCity), \(countryOfTheCity)"
            } else {
                return "\(localName), \(stateOfTheCity)"
            }
        } else {
            if let countryOfTheCity = self.country {
                return "\(localName), \(countryOfTheCity)"
            } else {
                return localName
            }
        }
    }
    
    var getCurrency: String {
        guard let currency = self.countryDetails?.currencies?[0].name else {
            return "unknown.currency".localized()
        }
        return currency
    }
    
    var getLanguage: String {
        guard let language = self.countryDetails?.languages?[0].nativeName else {
            return "unknown.language".localized()
        }
        return language.capitalized
    }
    
    /// Function that returns the city name based on the user's language.
    /// - Parameter languageKeys: user's language key
    /// - Returns: city name based on the user's language
    func getLocalName(languageKeys: Languages) -> String {
        guard let name = name else { return "no.city.name".localized() }
        var localName: String?
        switch languageKeys {
            case .fr: localName = localNames?.fr
            case .en: localName = localNames?.en
        }
        if let localName = localName { return localName } else { return name }
    }
    
}
