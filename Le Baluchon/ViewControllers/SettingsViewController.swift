//
//  SettingsViewController.swift
//  Le Baluchon
//
//  Created by Maxime Point on 25/11/2022.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var temperatureUnitSegmentedControl: UISegmentedControl!
    @IBOutlet weak var languagePickerView: UIPickerView!
    @IBOutlet weak var currentCity: UITextField!
    @IBOutlet weak var currentCityTableView: UITableView!
    @IBOutlet weak var destinationCity: UITextField!
    @IBOutlet weak var destinationCityTableView: UITableView!
    
    private let currentCityCellIdentifier = "CurrentCityCell"
    private let destinationCityCellIdentifier = "DestinationCityCell"
    
    private var datasOfCurrentCityTableView = [City]()
    private var datasOfDestinationCityTableView = [City]()
    
    /// List of Language Enum with alphabetical sorting
    private var languagesList: [Languages] = (Languages.allCases.map { $0 }).sorted { $0.description < $1.description }
    
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // language UIPickerView
        self.languagePickerView.dataSource = self
        self.languagePickerView.delegate = self
        // current city table view
        self.currentCityTableView.dataSource = self
        self.currentCityTableView.delegate = self
        // destination city table view
        self.destinationCityTableView.dataSource = self
        self.destinationCityTableView.delegate = self
        // UI setup
        setupUI()
        setupUserSettings()
    }
    
    
    // MARK: @IBAction
    @IBAction func currentCityChange(_ sender: Any) {
        if !(currentCity.text?.isEmpty ?? true) {
            currentCityTableView.isHidden = false
            LocationService.shared.city = currentCity.text!
            getCitiesList(cityType: .current)
        } else {
            currentCityTableView.isHidden = true
        }
    }
    
    @IBAction func destinationCityChange(_ sender: Any) {
        if !(destinationCity.text?.isEmpty ?? true) {
            destinationCityTableView.isHidden = false
            LocationService.shared.city = destinationCity.text!
            getCitiesList(cityType: .destination)
        } else {
            destinationCityTableView.isHidden = true
        }
    }
    
    @IBAction func temperatureUnitChange(_ sender: Any) {
        let temperatureUnitIndex = temperatureUnitSegmentedControl.selectedSegmentIndex
        let temperatureUnit: TemperatureUnit
        if temperatureUnitIndex == 0 {
            temperatureUnit = .Kelvin
        } else if temperatureUnitIndex == 1 {
            temperatureUnit = .Celsius
        } else {
            temperatureUnit = .Fahrenheit
        }
        UserSettings.shared.temperatureUnit = temperatureUnit
    }
    
    
    // MARK: function
    private func setupUI() {
        // TableView
        currentCityTableView.isHidden = true
        destinationCityTableView.isHidden = true
        // SegmentControl
        temperatureUnitSegmentedControl.removeAllSegments()
        TemperatureUnit.allCases.forEach {
            temperatureUnitSegmentedControl.insertSegment(withTitle: $0.rawValue,
                                                          at: temperatureUnitSegmentedControl.numberOfSegments,
                                                          animated: false)
        }
    }
    
    private func setupUserSettings() {
        // Picker
        let indexUserLanguage = languagesList.firstIndex(of: UserSettings.shared.userLanguage)!
        self.languagePickerView.selectRow(indexUserLanguage, inComponent: 0, animated: true)
        // TextField
        self.currentCity.text = UserSettings.shared.currentCity.getLocalName(languageKeys: UserSettings.shared.userLanguage)
        self.destinationCity.text = UserSettings.shared.destinationCity.getLocalName(languageKeys: UserSettings.shared.userLanguage)
        // SelectedSegment
        switch UserSettings.shared.temperatureUnit {
            case .Kelvin: self.temperatureUnitSegmentedControl.selectedSegmentIndex = 0
            case .Celsius: self.temperatureUnitSegmentedControl.selectedSegmentIndex = 1
            case .Fahrenheit: self.temperatureUnitSegmentedControl.selectedSegmentIndex = 2
        }
    }
    
    private func getCitiesList(cityType: CityType) {
        LocationService.shared.getLocation { success, cities in
            guard let cities = cities, success == true else {
                let retry = UIAlertAction(title: "Retry", style: .default) { _ in
                    self.getCitiesList(cityType: cityType)
                }
                self.alertUser(title: "Error", message: "The Locations download failed", actions: [retry])
                return
            }
            switch cityType {
                case .current:
                    self.datasOfCurrentCityTableView = cities
                    self.currentCityTableView.reloadData()
                    return
                case .destination:
                    self.datasOfDestinationCityTableView = cities
                    self.destinationCityTableView.reloadData()
                    return
            }
        }
    }
   
}



// MARK: UITableView
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return datasOfCurrentCityTableView.count // number of cells in each section
        } else {
            return datasOfDestinationCityTableView.count // number of cells in each section
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var city: City
        var cell: UITableViewCell
        
        if tableView.tag == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: currentCityCellIdentifier, for: indexPath)
            if datasOfCurrentCityTableView.count == 0 {
                return cell
            }
            city = datasOfCurrentCityTableView[indexPath.row]
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: destinationCityCellIdentifier, for: indexPath)
            if datasOfDestinationCityTableView.count == 0 {
                return cell
            }
            city = datasOfDestinationCityTableView[indexPath.row]
        }
        
        // TODO: gérer les optionnels dans le model plutot
        cell.textLabel?.text = city.getLocalName(languageKeys: UserSettings.shared.userLanguage)
        
        if let stateOfTheCity = city.state {
            if let countryOfTheCity = city.country {
                cell.detailTextLabel?.text = "\(stateOfTheCity) - \(countryOfTheCity)"
            } else {
                cell.detailTextLabel?.text = stateOfTheCity
            }
        } else {
            if let countryOfTheCity = city.country {
                cell.detailTextLabel?.text = countryOfTheCity
            } else {
                cell.detailTextLabel?.text = ""
            }
        }
        
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
            currentCityTableView.isHidden = true
            currentCity.text = datasOfCurrentCityTableView[indexPath.row].getLocalName(languageKeys: UserSettings.shared.userLanguage)
            UserSettings.shared.currentCity = datasOfCurrentCityTableView[indexPath.row]
        } else {
            destinationCityTableView.isHidden = true
            destinationCity.text = datasOfDestinationCityTableView[indexPath.row].getLocalName(languageKeys: UserSettings.shared.userLanguage)
            UserSettings.shared.destinationCity = datasOfDestinationCityTableView[indexPath.row]
        }
    }
}


// MARK: UIPickerView
extension SettingsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languagesList.count
    }
}

extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Add datas
        return languagesList[row].description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // When the user changes the selection
        let index = pickerView.selectedRow(inComponent: component)
        UserSettings.shared.userLanguage = languagesList[index]
        setupUserSettings()
    }
}
