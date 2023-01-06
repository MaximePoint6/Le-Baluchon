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
    @IBOutlet weak var screenDescription: UILabel!
    
    private var currentCityWeatherDateRefresh: Date?
    private var destinationCityWeatherDateRefresh: Date?
    private let timeForRefreshInSeconds: Double = 15 * 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegate
        topBar.delegate = self
        // UI
        setupUI()
        refreshScreen()
        // Notification when the user has changed a city or language or temperature unit in his settings
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.refreshAfterNotification(notification:)),
                                               name: .newCity,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.refreshAfterNotification(notification:)),
                                               name: .newLanguage,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.refreshAfterNotification(notification:)),
                                               name: .newTemperatureUnit,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        topBar.setupUI()
        // Screen refresh every 15min or if a city changes (see notification)
        if let currentCityWeatherDateRefresh = currentCityWeatherDateRefresh,
           let destinationCityWeatherDateRefresh = destinationCityWeatherDateRefresh,
           currentCityWeatherDateRefresh + timeForRefreshInSeconds < Date() ||
            destinationCityWeatherDateRefresh + timeForRefreshInSeconds < Date() {
            refreshScreen()
        }
    }
    
    @objc private func refreshAfterNotification(notification: Notification) {
        setupUI()
        refreshScreen()
    }
    
    private func refreshScreen() {
        getWeatherCities(cityType: .current)
    }
    
    private func setupUI() {
        screenDescription.text = "weather.description".localized()
    }
    
    private func getWeatherCities(cityType: CityType) {
        // Add Spinner during loading
        let spinner = SpinnerViewController()
        addSpinnerView(spinner: spinner)
        
        var city: City
        switch cityType {
            case .current:
                // Get Current City
                guard let currentCity = UserSettings.currentCity else {
                    return
                }
                city = currentCity
            case .destination:
                // Get Destination City
                guard let destinationCity = UserSettings.destinationCity else {
                    return
                }
                city = destinationCity
        }
        
        // Function making network call
        WeatherService.shared.getWeather(cityType: cityType) { error, weather in
            // Remove Spinner
            self.removeSpinnerView(spinner: spinner)
            
            // Get Weather or Alert
            guard let weather = weather, error == nil else {
                let retry = UIAlertAction(title: "retry".localized(), style: .default) { _ in
                    self.getWeatherCities(cityType: cityType)
                }
                let ok = UIAlertAction(title: "ok".localized(), style: .cancel) { _ in }
                self.alertUser(title: "error".localized(), message: error!.rawValue.localized(), actions: [retry, ok])
                return
            }
            switch cityType {
                case .current: self.currentCityWeatherDateRefresh = Date()
                case .destination: self.destinationCityWeatherDateRefresh = Date()
            }
            self.updateUI(cityType: cityType, city: city, weather: weather)
        }
    }
    
    
    private func updateUI(cityType: CityType, city: City, weather: Weather) {
        switch cityType {
            case .current:
                self.currentCityWeather.cityNameLabel.text = city.getLocalName(languageKeys:
                                                                                UserSettings.userLanguage)
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
                                                                                    UserSettings.userLanguage)
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


// MARK: TOPBAR
extension WeatherViewController: ContainsTopBar {
    // Segue
    func didClickSettings() {
        performSegue(withIdentifier: .segueToSettingsView, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == .segueToSettingsView {
            _ = segue.destination as? SettingsViewController
        }
    }
}


// MARK: SpinnerView
extension WeatherViewController {
    private func addSpinnerView(spinner: SpinnerViewController) {
        // Add the spinner view controller
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    private func removeSpinnerView(spinner: SpinnerViewController) {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
}
