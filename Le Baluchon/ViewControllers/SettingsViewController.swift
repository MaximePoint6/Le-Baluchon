//
//  SettingsViewController.swift
//  Le Baluchon
//
//  Created by Maxime Point on 25/11/2022.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var temperatureUnitLabel: UISegmentedControl!
    @IBOutlet weak var language: UIPickerView!
    @IBOutlet weak var currentCity: UITextField!
    @IBOutlet weak var currentCityAutocompletion: UITableView!
    @IBOutlet weak var destinationCity: UITextField!
    @IBOutlet weak var destinationCityAutocompletion: UITableView!
    
    private let currentCityCellIdentifier = "CurrentCityCell"
    private let destinationCityCellIdentifier = "DestinationCityCell"
    
    private var resultsOfCurrentCityAutocompletion = [City]()
    private var resultsOfDestinationCityAutocompletion = [City]()
    
    private let languagesList = Array(languages.values).sorted { $0 < $1 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // language UIPickerView
        self.language.dataSource = self
        self.language.delegate = self
        // current city table view
        self.currentCityAutocompletion.dataSource = self
        self.currentCityAutocompletion.delegate = self
        // destination city table view
        self.destinationCityAutocompletion.dataSource = self
        self.destinationCityAutocompletion.delegate = self
        // UI setup
        currentCityAutocompletion.isHidden = true
        destinationCityAutocompletion.isHidden = true
        setupContent()
    }
    
    @IBAction func currentCityChange(_ sender: Any) {
        if currentCity.text!.count != 0 {
            currentCityAutocompletion.isHidden = false
            LocationService.shared.city = currentCity.text!
            getCurrentCitiesList()
        } else {
            currentCityAutocompletion.isHidden = true
        }
    }
    
    @IBAction func destinationCityChange(_ sender: Any) {
        // TODO: faire cette partie, mais attention savoir gérer 2 tableView différents, voir fonction dans delegate
    }
    
    @IBAction func temperatureUnitChange(_ sender: Any) {
        let temperatureUnitIndex = temperatureUnitLabel.selectedSegmentIndex
        let temperatureUnit: TemperatureUnitPreference
        if temperatureUnitIndex == 0 {
            temperatureUnit = .Kelvin
        } else if temperatureUnitIndex == 1 {
            temperatureUnit = .Celsius
        } else {
            temperatureUnit = .Fahrenheit
        }
        UserSettings.shared.temperatureUnitPreference = temperatureUnit
    }
    
    private func setupContent() {
        self.currentCity.text = UserSettings.shared.currentCity.name
        self.destinationCity.text = UserSettings.shared.destinationCity.name
        
        let indexUserLanguage = languagesList.firstIndex(of: UserSettings.shared.userLanguageValue)!
        self.language.selectRow(indexUserLanguage, inComponent: 0, animated: true)
        
        switch UserSettings.shared.temperatureUnitPreference {
        case .Kelvin: temperatureUnitLabel.selectedSegmentIndex = 0
        case .Celsius: temperatureUnitLabel.selectedSegmentIndex = 1
        case .Fahrenheit: temperatureUnitLabel.selectedSegmentIndex = 2
        }
    }
    
    private func getCurrentCitiesList() {
        LocationService.shared.getLocation { success, cities in
            guard let cities = cities, success == true else {
                let retry = UIAlertAction(title: "Retry", style: .default) { _ in
                    self.getCurrentCitiesList()
                }
                self.alertUser(title: "Error", message: "The Locations download failed", actions: [retry])
                return
            }
            self.resultsOfCurrentCityAutocompletion = cities
            self.currentCityAutocompletion.reloadData()
        }
    }
    
}

// MARK: UITableView
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsOfCurrentCityAutocompletion.count // number of cells in each section
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: currentCityCellIdentifier, for: indexPath)
        if resultsOfCurrentCityAutocompletion.count != 0 {
            let city = resultsOfCurrentCityAutocompletion[indexPath.row]
            cell.textLabel?.text = city.name
            cell.detailTextLabel?.text = "\(city.state) - \(city.country)"
        } else {
            cell.textLabel?.text = ""
        }
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentCityAutocompletion.isHidden = true
        currentCity.text = resultsOfCurrentCityAutocompletion[indexPath.row].name
        UserSettings.shared.currentCity = resultsOfCurrentCityAutocompletion[indexPath.row]
    }
}

// MARK: UIAlertController
extension SettingsViewController {
    func alertUser(title: String, message: String, actions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let actions = actions {
            actions.forEach { alert.addAction($0) }
        } else {
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        }
        present(alert, animated: true)
    }
}

// MARK: UIPickerView
extension SettingsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
}

extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Add datas
        return languagesList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // When the user changes the selection
        let index = pickerView.selectedRow(inComponent: component)
        let value = languagesList[index]
        if let key = languages.someKey(forValue: value) {
            UserSettings.shared.userLanguageKeys = key
        }
    }
}
