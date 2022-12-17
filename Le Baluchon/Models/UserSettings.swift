//
//  UserSettings.swift
//  Le Baluchon
//
//  Created by Maxime Point on 25/11/2022.
//

import Foundation
import UIKit

class UserSettings {
    static var shared = UserSettings()
    private init() {}

    var userName = ""
    var userPicture: UIImage?
    var userLanguage: Languages = .en
    var currentCity: City?
    var destinationCity: City?
    var temperatureUnit: TemperatureUnit = .Celsius
}
