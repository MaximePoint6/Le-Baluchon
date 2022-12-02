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

    var userLanguage: Languages = .en
    
    // TODO: Mettre optionel ici plutot que city vide (pour les deux), et du coup si City vide, mettre une alerte pour que l'utilisateur puisse choisir
    var currentCity: City = City()
    var destinationCity: City = City()
    
    var temperatureUnit: TemperatureUnit = .Celsius
}
