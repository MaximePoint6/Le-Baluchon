//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Maxime Point on 20/11/2022.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var topBar: TopBarComponentView!
    @IBOutlet weak var currentCityWeather: WeatherComponentView!
    @IBOutlet weak var destinationCityWeather: WeatherComponentView!
    @IBOutlet weak var screenDescription: UILabel!
    
    // MARK: - Properties
    private var lastRefreshOfCurrentCityWeather: Date?
    private var lastRefreshOfDestinationCityWeather: Date?
    private let timeForRefreshInSeconds: Double = 15 * 60
    
    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegate
        topBar.delegate = self
        // UI
        setupUI()
        refreshWeather()
        // Notification when the user has changed a city, language or temperature unit in his settings.
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
        // Screen refreshes every 15min minimum, or if a city changes (see notification).
        if let lastRefreshOfCurrentCityWeather = lastRefreshOfCurrentCityWeather,
           let lastRefreshOfDestinationCityWeather = lastRefreshOfDestinationCityWeather,
           lastRefreshOfCurrentCityWeather + timeForRefreshInSeconds < Date() ||
            lastRefreshOfDestinationCityWeather + timeForRefreshInSeconds < Date() {
            refreshWeather()
        }
    }
    
    // MARK: - Private functions
    @objc private func refreshAfterNotification(notification: Notification) {
        setupUI()
        refreshWeather()
    }
    
    private func refreshWeather() {
        getWeatherCities(cityType: .current)
    }
    
    private func setupUI() {
        screenDescription.text = "weather.description".localized()
    }
    
    /// Function performing another function that runs a network call in order to get the city weather forecast.
    /// - Parameter cityType: Desired city to retrieve his weather (type: current or destination).
    private func getWeatherCities(cityType: CityType) {
        // Add Spinner during loading
        let spinner = SpinnerViewController()
        addSpinnerView(spinner: spinner)
        
        // Get Current or Destination City
        var city: City
        switch cityType {
            case .current:
                guard let currentCity = UserSettings.currentCity else { return }
                city = currentCity
            case .destination:
                guard let destinationCity = UserSettings.destinationCity else { return }
                city = destinationCity
        }
        
        // Function executing the network call
        WeatherService.shared.getWeather(cityType: cityType) { error, weather in
            // Remove Spinner because the network call was answered
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
            
            // Save the date of last weather Refresh
            switch cityType {
                case .current: self.lastRefreshOfCurrentCityWeather = Date()
                case .destination: self.lastRefreshOfDestinationCityWeather = Date()
            }
            
            // UI
            self.updateUI(cityType: cityType, city: city, weather: weather)
        }
    }
    
    
    private func updateUI(cityType: CityType, city: City, weather: Weather) {
        switch cityType {
            case .current:
                self.currentCityWeather.cityNameLabel.text = city.getLocalName(languageKeys: UserSettings.userLanguage)
                self.currentCityWeather.skyLabel.text = weather.mainWeatherDescription.capitalizedSentence
                self.currentCityWeather.temperatureLabel.text = weather.tempLabel
                self.currentCityWeather.localDate.text = weather.localDate
                
                if let weatherIcon = weather.mainWeatherIcon {
                    self.currentCityWeather.iconWeather.downloaded(
                        from: String(format: Weather.iconUrlBase, weatherIcon))
                } else {
                    self.currentCityWeather.iconWeather.image = UIImage.emptyImage
                }
                
                // Get Weather Destination City
                self.getWeatherCities(cityType: .destination)
                
            case .destination:
                self.destinationCityWeather.cityNameLabel.text = city.getLocalName(languageKeys:
                                                                                    UserSettings.userLanguage)
                self.destinationCityWeather.skyLabel.text = weather.mainWeatherDescription.capitalizedSentence
                self.destinationCityWeather.temperatureLabel.text = weather.tempLabel
                self.destinationCityWeather.localDate.text = weather.localDate
                
                if let weatherIcon = weather.mainWeatherIcon {
                    self.destinationCityWeather.iconWeather.downloaded(
                        from: String(format: Weather.iconUrlBase, weatherIcon))
                } else {
                    self.destinationCityWeather.iconWeather.image = UIImage.emptyImage
                }
        }
    }
    
    
}


// MARK: TOPBAR
extension WeatherViewController: ContainsTopBar {
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
    /// Add the spinner
    private func addSpinnerView(spinner: SpinnerViewController) {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    /// Remove the spinner
    private func removeSpinnerView(spinner: SpinnerViewController) {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
}
