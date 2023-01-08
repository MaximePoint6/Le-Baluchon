//
//  City.swift
//  Le Baluchon
//
//  Created by Maxime Point on 25/11/2022.
//

import Foundation

struct City: Codable {

    // MARK: Data retrieved from the network call
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
        var fi: String?
    }
    
    
    // MARK: Tools for ViewControllers
    /// Variable returning the state and the country of the city (or just the not nil one, in that order).
    var stateAndCountryDetails: String {
        return [self.state, self.country].compactMap { $0 }.joined(separator: ", ")
    }
    
    /// Function returning the local name of the city, with its state and country (or just those not nil, in that order)
    /// - Parameter languageKeys: Desired language of the result.
    /// - Returns: Local name of the city, with its state and country.
    func getNameWithStateAndCountry(languageKeys: Languages) -> String {
        let localName = getLocalName(languageKeys: languageKeys)
        return [localName, self.state, self.country].compactMap { $0 }.joined(separator: ", ")
    }
    
    /// Variable returning the currency of the city (with its symbol).
    var getCurrency: String {
        guard let currency = self.countryDetails?.currencies?[0].name else { return "unknown.currency".localized() }
        return [currency, self.countryDetails?.currencies?[0].symbol].compactMap { $0 }.joined(separator: " - ")
    }
    
    /// Variable returning the language of the city (native name).
    var getLanguage: String {
        guard let language = self.countryDetails?.languages?[0].nativeName else { return "unknown.language".localized() }
        return language.capitalized
    }
    
    /// Function that returns the city name based on the user's language.
    /// - Parameter languageKeys: User's language key.
    /// - Returns: City name based on the user's language.
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
