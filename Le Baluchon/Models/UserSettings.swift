//
//  UserSettings.swift
//  Le Baluchon
//
//  Created by Maxime Point on 25/11/2022.
//

import Foundation
import UIKit

struct UserSettings {
    
    /// User Name recorded in the UserDefaults of the application.
    static var userName: String {
        get {
            guard let temporaryUserName = UserDefaults.standard.object(forKey: UserDefaultsKeys.userName.rawValue) as? String,
                    temporaryUserName != "" else { return "the.traveler".localized() }
            return temporaryUserName
        }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.userName.rawValue) }
    }
    
    /// User Picture recorded in the UserDefaults of the application.
    static var userPicture: UIImage? {
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.userPicture.rawValue),
                  let responseJSON = try? PropertyListDecoder().decode(Data.self, from: data) else { return nil }
            return UIImage(data: responseJSON)
        }
        set {
            guard let newImage = newValue,
                  let compressedImage = newImage.jpegData(compressionQuality: 0.5),
                  let dataJSON = try? PropertyListEncoder().encode(compressedImage) else { return }
            UserDefaults.standard.set(dataJSON, forKey: UserDefaultsKeys.userPicture.rawValue)
        }
    }
    
    /// User Language recorded in the UserDefaults of the application.
    static var userLanguage: Languages {
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.userLanguage.rawValue),
                  let responseJSON = try? JSONDecoder().decode(Languages.self, from: data) else {
                // Checks if the device language is available in the app languages, if not then .en by default
                if let lang = Languages(rawValue: String(Locale.preferredLanguages[0].prefix(2))) {
                    return lang
                } else {
                    return .en
                }
            }
            return responseJSON
        }
        set {
            guard let dataJSON = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(dataJSON, forKey: UserDefaultsKeys.userLanguage.rawValue)
        }
    }
    
    /// User's current city recorded in the UserDefaults of the application.
    static var currentCity: City? {
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.currentCity.rawValue),
                  let responseJSON = try? JSONDecoder().decode(City.self, from: data) else { return nil }
            return responseJSON
        }
        set {
            guard let dataJSON = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(dataJSON, forKey: UserDefaultsKeys.currentCity.rawValue)
        }
    }
    
    /// User's destination city recorded in the UserDefaults of the application.
    static var destinationCity: City? {
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.destinationCity.rawValue),
                  let responseJSON = try? JSONDecoder().decode(City.self, from: data) else { return nil }
            return responseJSON
        }
        set {
            guard let dataJSON = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(dataJSON, forKey: UserDefaultsKeys.destinationCity.rawValue)
        }
    }
    
    /// User preferred temperature unit recorded in the UserDefaults of the application.
    static var temperatureUnit: TemperatureUnit {
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.temperatureUnit.rawValue),
                  let responseJSON = try? JSONDecoder().decode(TemperatureUnit.self, from: data) else {
                return .Celsius
            }
            return responseJSON
        }
        set {
            guard let dataJSON = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(dataJSON, forKey: UserDefaultsKeys.temperatureUnit.rawValue)
        }
    }
    
    /// Indicates if the user has already seen the application on boarding screen, and save it in the UserDefaults of the application.
    static var onBoardingScreenWasShown: Bool {
        get { return UserDefaults.standard.bool(forKey: UserDefaultsKeys.onBoardingScreenWasShown.rawValue) }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.onBoardingScreenWasShown.rawValue) }
    }
    
    
}
