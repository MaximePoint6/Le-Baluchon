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
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPicture: UIImageView!
    
    private let settingCellIdentifier = "SettingCell"
    private let segueToSearchCity = "segueToSearchCity"
    
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
        // settings table view
        self.settingsTableView.dataSource = self
        self.settingsTableView.delegate = self
        // UI setup
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUserSettings()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToSearchCity {
            let VC = segue.destination as? SearchCityViewController
            let cityType = sender as? CityType
            VC?.cityType = cityType ?? .current
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
    
    
    @IBAction func validateButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func userNamehasBeenEdited(_ sender: Any) {
        if let userName = userName.text {
            UserSettings.shared.userName = userName
        }
    }
    
    // MARK: function
    private func setupUI() {
        // SegmentControl
        temperatureUnitSegmentedControl.removeAllSegments()
        TemperatureUnit.allCases.forEach {
            temperatureUnitSegmentedControl.insertSegment(withTitle: $0.rawValue,
                                                          at: temperatureUnitSegmentedControl.numberOfSegments,
                                                          animated: false)
        }
    }
    
    private func setupUserSettings() {
        // textField
        userName.text = UserSettings.shared.userName
        // UIImageView
        userPicture.image = UserSettings.shared.userPicture
        // Picker
        let indexUserLanguage = languagesList.firstIndex(of: UserSettings.shared.userLanguage)!
        self.languagePickerView.selectRow(indexUserLanguage, inComponent: 0, animated: true)
        // TableView
        settingsTableView.reloadData()
        // SelectedSegment
        switch UserSettings.shared.temperatureUnit {
            case .Kelvin: self.temperatureUnitSegmentedControl.selectedSegmentIndex = 0
            case .Celsius: self.temperatureUnitSegmentedControl.selectedSegmentIndex = 1
            case .Fahrenheit: self.temperatureUnitSegmentedControl.selectedSegmentIndex = 2
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
        } else if tableView.tag == 1 {
            return datasOfDestinationCityTableView.count // number of cells in each section
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingCellIdentifier, for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "Current City"
            if let city = UserSettings.shared.currentCity {
                cell.detailTextLabel?.text = city.getNameWithStateAndCountry(
                    languageKeys: UserSettings.shared.userLanguage)
            } else {
                cell.detailTextLabel?.text = "City name not specified"
            }
        } else {
            cell.textLabel?.text = "Destination City"
            if let city = UserSettings.shared.destinationCity {
                cell.detailTextLabel?.text = city.getNameWithStateAndCountry(
                    languageKeys: UserSettings.shared.userLanguage)
            } else {
                cell.detailTextLabel?.text = "City name not specified"
            }
        }
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: segueToSearchCity, sender: CityType.current)
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: segueToSearchCity, sender: CityType.destination)
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
        // for get cities local names
        settingsTableView.reloadData()
    }
}
