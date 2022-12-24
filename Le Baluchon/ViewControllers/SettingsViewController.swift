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
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPicture: UIImageView!
    
    private let settingCellIdentifier = "SettingCell"
    private let segueToSearchCity = "segueToSearchCity"
    private let segueToSearchLanguage = "segueToSearchLanguage"
    
    private var datasOfCurrentCityTableView = [City]()
    private var datasOfDestinationCityTableView = [City]()
    
    /// List of Language Enum with alphabetical sorting
    private var languagesList: [Languages] = (Languages.allCases.map { $0 }).sorted { $0.description < $1.description }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        UserSettings.temperatureUnit = temperatureUnit
    }
    
    
    @IBAction func validateButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func userNamehasBeenEdited(_ sender: Any) {
        if let userName = userName.text {
            UserSettings.userName = userName
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
        // textField
        userName.uiCustomization()
    }
    
    private func setupUserSettings() {
        // textField
        userName.text = UserSettings.userName
        // UIImageView
        userPicture.image = UserSettings.userPicture
        // TableView
        settingsTableView.reloadData()
        // SelectedSegment
        switch UserSettings.temperatureUnit {
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingCellIdentifier, for: indexPath)
        let cityNotSpecified = "city.not.specified".localized()
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "language".localized()
            cell.detailTextLabel?.text = UserSettings.userLanguage.description
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "current.city".localized()
            if let city = UserSettings.currentCity {
                cell.detailTextLabel?.text = city.getNameWithStateAndCountry(
                    languageKeys: UserSettings.userLanguage)
            } else {
                cell.detailTextLabel?.text = cityNotSpecified
            }
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "destination.city".localized()
            if let city = UserSettings.destinationCity {
                cell.detailTextLabel?.text = city.getNameWithStateAndCountry(
                    languageKeys: UserSettings.userLanguage)
            } else {
                cell.detailTextLabel?.text = cityNotSpecified
            }
        } else { }
        return cell
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: segueToSearchLanguage, sender: nil)
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: segueToSearchCity, sender: CityType.current)
        } else if indexPath.row == 2 {
            performSegue(withIdentifier: segueToSearchCity, sender: CityType.destination)
        }
    }
}
