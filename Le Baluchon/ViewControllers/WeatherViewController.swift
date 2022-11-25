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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func getWeather(_ sender: Any) {
        WeatherService.shared.lat = UserSettings.shared.currentCity.lat ?? 0
        WeatherService.shared.lon = UserSettings.shared.currentCity.lon ?? 0
        WeatherService.shared.getWeather { success, weather in
            guard let weather = weather, success == true else {
                self.presentAlert()
                return
            }
            self.skyLabel.text = weather.weather[0].main  // attention temporaire : à modifier car si il y a pas de valeur ca plante
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
