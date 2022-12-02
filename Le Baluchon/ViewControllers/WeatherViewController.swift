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

    @IBAction func getWeather(_ sender: Any) {
        getWeatherCurrentCity()
        getWeatherDestinationCity()
    }
    
    
    private func getWeatherCurrentCity() {
        guard let currentCityLat = UserSettings.shared.currentCity.lat,
                let currentCityLon = UserSettings.shared.currentCity.lon else {
            return
        }
        
        WeatherService.shared.lat = currentCityLat
        WeatherService.shared.lon = currentCityLon
        WeatherService.shared.lang = UserSettings.shared.userLanguageKeys
        
        WeatherService.shared.getWeather { success, weather in
            guard let weather = weather, success == true else {
                let retry = UIAlertAction(title: "Retry", style: .default) { _ in
                    self.getWeatherCurrentCity()
                }
                self.alertUser(title: "Error", message: "The Weather download failed", actions: [retry])
                return
            }
            
            self.currentCityNameLabel.text = UserSettings.shared.currentCity.localName(languageKeys: UserSettings.shared.userLanguageKeys)
            
            if weather.weather.count > 0 {
                if let weatherDescription = weather.weather[0].description {
                    self.currentCitySkyLabel.text = weatherDescription
                } else {
                    self.currentCitySkyLabel.text = "-"
                }
                if let weatherIcon = weather.weather[0].icon {
                    self.currentCityIconWeather.downloaded(from: String(format: "https://openweathermap.org/img/wn/%@@2x.png", weatherIcon))
                } else {
                    self.currentCityIconWeather.image = UIImage.emptyImage
                }
            } else {
                self.currentCitySkyLabel.text = "-"
                self.currentCityIconWeather.image = UIImage.emptyImage
            }
            
            if let tempPreference = weather.main?.tempPreference {
                self.currentCityTemperatureLabel.text = String(format: "%.1f %@", tempPreference, UserSettings.shared.temperatureUnitPreference.rawValue)
            } else {
                self.currentCityTemperatureLabel.text = "- \(UserSettings.shared.temperatureUnitPreference.rawValue)"
            }
        }
    }
    
    private func getWeatherDestinationCity() {
        // code
    }
    
    
    
}
