//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Maxime Point on 20/11/2022.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var topBar: TopBarComponentView!
    @IBOutlet weak var currentCityWeather: WeatherComponentView!
    @IBOutlet weak var destinationCityWeather: WeatherComponentView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topBar.delegate = self
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
        getWeatherCities(cityType: .current)
        topBar.setupUI()
    }
    
    private func getWeatherCities(cityType: CityType) {
        var city: City
        switch cityType {
            case .current:
                // Get Current City
                guard let currentCity = UserSettings.shared.currentCity else {
                    return
                }
                city = currentCity
            case .destination:
                // Get Destination City
                guard let destinationCity = UserSettings.shared.destinationCity else {
                    return
                }
                city = destinationCity
        }
        
        // Function making network call
        WeatherService.shared.getWeather(cityType: cityType) { error, weather in
            
            // Get Weather or Alert
            guard let weather = weather, error == nil else {
                let retry = UIAlertAction(title: "Retry".localized(), style: .default) { _ in
                    self.getWeatherCities(cityType: cityType)
                }
                let ok = UIAlertAction(title: "Ok".localized(), style: .cancel) { _ in }
                self.alertUser(title: "Error".localized(), message: error!.rawValue, actions: [retry, ok])
                return
            }
            
            // Update UI
            switch cityType {
                case .current:
                    self.currentCityWeather.cityNameLabel.text = city.getLocalName(languageKeys:
                                                                        UserSettings.shared.userLanguage)
                    self.currentCityWeather.skyLabel.text = weather.mainWeatherDescription.capitalizedSentence
                    self.currentCityWeather.temperatureLabel.text = weather.tempLabel
                    self.currentCityWeather.localDate.text = weather.localDate
                    
                    if let weatherIcon = weather.mainWeatherIcon {
                        self.currentCityWeather.iconWeather.downloaded(
                            from: String(format: "https://openweathermap.org/img/wn/%@@2x.png", weatherIcon))
                    } else {
                        self.currentCityWeather.iconWeather.image = UIImage.emptyImage
                    }
                    
                    //  // Get Weather Destination City
                    self.getWeatherCities(cityType: .destination)
                    
                case .destination:
                    self.destinationCityWeather.cityNameLabel.text = city.getLocalName(languageKeys:
                                                                            UserSettings.shared.userLanguage)
                    self.destinationCityWeather.skyLabel.text = weather.mainWeatherDescription.capitalizedSentence
                    self.destinationCityWeather.temperatureLabel.text = weather.tempLabel
                    self.destinationCityWeather.localDate.text = weather.localDate
                    
                    if let weatherIcon = weather.mainWeatherIcon {
                        self.destinationCityWeather.iconWeather.downloaded(
                            from: String(format: "https://openweathermap.org/img/wn/%@@2x.png", weatherIcon))
                    } else {
                        self.destinationCityWeather.iconWeather.image = UIImage.emptyImage
                    }
            }
        }
    }
}

extension WeatherViewController: ContainsTopBar {
    // Segue
    func didClickSettings() {
        performSegue(withIdentifier: "segueToSettingsView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSettingsView" {
            _ = segue.destination as? SettingsViewController
        }
    }
}
