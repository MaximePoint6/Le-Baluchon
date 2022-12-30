//
//  UserSettings.swift
//  Le Baluchon
//
//  Created by Maxime Point on 25/11/2022.
//

import Foundation
import UIKit

// save UserSettings in UserDefault
struct UserSettings {
    
    static var userName: String {
        get {
            guard let temporaryUserName = UserDefaults.standard.object(forKey: UserDefaultsKeys.userName.rawValue) as? String,
                    temporaryUserName != "" else { return "the.traveler".localized() }
            return temporaryUserName
        }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.userName.rawValue) }
    }
    
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
    
    
    static var userLanguage: Languages {
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.userLanguage.rawValue),
                    let responseJSON = try? JSONDecoder().decode(Languages.self, from: data) else { return .en }
            return responseJSON
        }
        set {
            guard let dataJSON = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(dataJSON, forKey: UserDefaultsKeys.userLanguage.rawValue)
        }
    }
    
    
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
    
    
    static var temperatureUnit: TemperatureUnit {
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.temperatureUnit.rawValue),
                  let responseJSON = try? JSONDecoder().decode(TemperatureUnit.self, from: data) else { return .Celsius }
            return responseJSON
        }
        set {
            guard let dataJSON = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(dataJSON, forKey: UserDefaultsKeys.temperatureUnit.rawValue)
        }
    }
    
    static var onBoardingScreenWasShown: Bool {
        get { return UserDefaults.standard.bool(forKey: UserDefaultsKeys.onBoardingScreenWasShown.rawValue) }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.onBoardingScreenWasShown.rawValue) }
    }
    
    
}
