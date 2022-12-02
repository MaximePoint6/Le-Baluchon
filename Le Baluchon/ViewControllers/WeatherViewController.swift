//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Maxime Point on 20/11/2022.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var skyLabel: UILabel!
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var iconWeather: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func getWeather(_ sender: Any) {
        WeatherService.shared.lat = UserSettings.shared.currentCity.lat ?? 0
        WeatherService.shared.lon = UserSettings.shared.currentCity.lon ?? 0
        WeatherService.shared.lang = UserSettings.shared.userLanguageKeys
        WeatherService.shared.getWeather { success, weather in
            guard let weather = weather, success == true else {
                self.presentAlert()
                return
            }
            self.skyLabel.text = weather.weather[0].description  // attention temporaire : à modifier car si il y a pas de valeur ca plante
            self.currentCityLabel.text = UserSettings.shared.currentCity.name
            self.iconWeather.downloaded(from: String(format: "https://openweathermap.org/img/wn/%@@2x.png", weather.weather[0].icon!))
            if let tempPreference = weather.main?.tempPreference {
                self.temperatureLabel.text = String(format: "%.1f %@", tempPreference, UserSettings.shared.temperatureUnitPreference.rawValue)
            } else {
                self.temperatureLabel.text = "- \(UserSettings.shared.temperatureUnitPreference.rawValue)"
            }
        }
    }
}

extension WeatherViewController {
    func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The Weather download failed", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
}
