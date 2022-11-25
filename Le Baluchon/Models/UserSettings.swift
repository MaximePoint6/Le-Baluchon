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

    var language: String = languages["fr"] ?? "French"
    var currentCity: City = City()
    var destinationCity: City = City()

}
