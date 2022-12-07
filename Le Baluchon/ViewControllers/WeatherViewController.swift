//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Maxime Point on 20/11/2022.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var currentCitySkyLabel: UILabel!
    @IBOutlet weak var currentCityNameLabel: UILabel!
    @IBOutlet weak var currentCityTemperatureLabel: UILabel!
    @IBOutlet weak var currentCityIconWeather: UIImageView!
    
    @IBOutlet weak var destinationCitySkyLabel: UILabel!
    @IBOutlet weak var destinationCityNameLabel: UILabel!
    @IBOutlet weak var destinationCityTemperatureLabel: UILabel!
    @IBOutlet weak var destinationCityIconWeather: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if UserSettings.shared.currentCity == nil && UserSettings.shared.destinationCity == nil {
//            let okButton = UIAlertAction(title: "Ok", style: .default) { _ in
//                self.present(SettingsViewController(), animated: true)
//            }
//            self.alertUser(title: "Unknown cities",
//                           message: "You must enter your current city and your destination city.",
//                           actions: [okButton])
//            return
//        }
        getWeatherCurrentCity()
    }
    
    private func getWeatherCurrentCity() {
        guard let currentCity = UserSettings.shared.currentCity,
              let currentCityLat = currentCity.lat,
              let currentCityLon = currentCity.lon else {
            return
        }
        WeatherService.shared.lat = currentCityLat
        WeatherService.shared.lon = currentCityLon
        WeatherService.shared.lang = UserSettings.shared.userLanguage.rawValue
        
        // Function making network call
        WeatherService.shared.getWeather { success, weather in
            guard let weather = weather, success == true else {
                let retry = UIAlertAction(title: "Retry", style: .default) { _ in
                    self.getWeatherCurrentCity()
                }
                self.alertUser(title: "Error", message: "The Weather download failed", actions: [retry])
                return
            }
            // update UI
            self.currentCityNameLabel.text = currentCity.getLocalName(languageKeys: UserSettings.shared.userLanguage)
            self.currentCitySkyLabel.text = weather.mainWeatherDescription
            self.currentCityTemperatureLabel.text = "\(weather.main?.tempWithPreferredUnit ?? "-") \(UserSettings.shared.temperatureUnit.unit)"
            
            if let weatherIcon = weather.mainWeatherIcon {
                self.currentCityIconWeather.downloaded(from: String(format: "https://openweathermap.org/img/wn/%@@2x.png", weatherIcon))
            } else {
                self.currentCityIconWeather.image = UIImage.emptyImage
            }
            // TODO: à déplacer, pas terrible ici pour enchainement des requêtes
            self.getWeatherDestinationCity()
        }
    }
    
    private func getWeatherDestinationCity() {
        guard let destinationCity = UserSettings.shared.destinationCity,
              let destinationCityLat = destinationCity.lat,
              let destinationCityLon = destinationCity.lon else {
            return
        }
        WeatherService.shared.lat = destinationCityLat
        WeatherService.shared.lon = destinationCityLon
        WeatherService.shared.lang = UserSettings.shared.userLanguage.rawValue
        
        // Function making network call
        WeatherService.shared.getWeather { success, weather in
            guard let weather = weather, success == true else {
                let retry = UIAlertAction(title: "Retry", style: .default) { _ in
                    self.getWeatherDestinationCity()
                }
                self.alertUser(title: "Error", message: "The Weather download failed", actions: [retry])
                return
            }
            // update UI
            self.destinationCityNameLabel.text = destinationCity.getLocalName(languageKeys: UserSettings.shared.userLanguage)
            self.destinationCitySkyLabel.text = weather.mainWeatherDescription
            self.destinationCityTemperatureLabel.text = "\(weather.main?.tempWithPreferredUnit ?? "-") \(UserSettings.shared.temperatureUnit.unit)"
            
            if let weatherIcon = weather.mainWeatherIcon {
                self.destinationCityIconWeather.downloaded(from: String(format: "https://openweathermap.org/img/wn/%@@2x.png", weatherIcon))
            } else {
                self.destinationCityIconWeather.image = UIImage.emptyImage
            }
        }
    }
    
    
    
}
