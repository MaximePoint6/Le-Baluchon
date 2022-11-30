//
//  UserSettings.swift
//  Le Baluchon
//
//  Created by Maxime Point on 25/11/2022.
//

import Foundation

class UserSettings {

    static var shared = UserSettings()
    private init() {}

    var userLanguageKeys: String = "en"
    
    var userLanguageValue: String {
        if let index = languages.index(forKey: userLanguageKeys) {
            return languages[index].value
        }
        return "English"
    }
    
    var currentCity: City = City()
    var destinationCity: City = City()
    
    var temperatureUnitPreference: TemperatureUnitPreference = .Celsius

}
