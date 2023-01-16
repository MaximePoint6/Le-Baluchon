//
//  SearchCityViewController.swift
//  Le Baluchon
//
//  Created by Maxime Point on 07/12/2022.
//

import Foundation
import UIKit


class SearchCityViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityTableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - Properties
    private let cityCellIdentifier = "CityCell"
    private var datasOfCityTableView = [City]()
    var cityType: CityType = .current
    
    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegate and dataSource
        self.searchBar.delegate = self
        self.cityTableView.dataSource = self
        self.cityTableView.delegate = self
        // UI
        setupUI()
    }
    
    // MARK: - Actions
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Private functions
    private func setupUI() {
        cancelButton.setTitle("cancel".localized(), for: .normal)
        searchBar.placeholder = "city".localized()
    }
    
    
    /// Function executing another function that runs a network call in order to get a list of cities,
    /// named according to the city sent in function parameters (or starting with the same letters).
    /// Finally, once the data is collected, it adds it to the tableView
    /// - Parameter city: Part or full name of a city.
    private func getCitiesList(city: String) {
        CityService.shared.getCities(city: city) { error, cities in
            // Get Cities or Alert
            guard let cities = cities, error == nil else {
                if error == ServiceError.noData {
                    return
                } else {
                    let retry = UIAlertAction(title: "retry".localized(), style: .default) { _ in
                        self.getCitiesList(city: city)
                    }
                    let ok = UIAlertAction(title: "ok".localized(), style: .cancel) { _ in }
                    self.alertUser(title: "error".localized(),
                                   message: error!.rawValue.localized(),
                                   actions: [retry, ok])
                    return
                }
            }
            self.datasOfCityTableView = cities
            self.cityTableView.reloadData()
        }
    }
    
    /// Function performing another function that runs a network call in order to get the city country details.
    /// - Parameter cityType: Desired city to retrieve his country details (type: current or destination).
    private func getCountryDetails(cityType: CityType) {
        CountryService.shared.getCountryDetails(cityType: cityType) { error, countryDetails in
            guard let countryDetails = countryDetails, error == nil else {
                if error == ServiceError.noData {
                    return
                } else {
                    let retry = UIAlertAction(title: "retry".localized(), style: .default) { _ in
                        self.getCountryDetails(cityType: cityType)
                    }
                    let ok = UIAlertAction(title: "ok".localized(), style: .cancel) { _ in }
                    self.alertUser(title: "error".localized(),
                                   message: error!.rawValue.localized(),
                                   actions: [retry, ok])
                    return
                }
            }
            self.saveCountryDetail(cityType: cityType, countryDetails: countryDetails)
        }
    }
    
    /// Function saves the country details in UserSettings
    /// - Parameters:
    ///   - cityType: Desired city to save his country details (type: current or destination).
    ///   - countryDetails: Country details data
    private func saveCountryDetail(cityType: CityType, countryDetails: City.CountryDetails) {
        switch cityType {
            case .current:
                UserSettings.currentCity?.countryDetails = countryDetails
            case .destination:
                UserSettings.destinationCity?.countryDetails = countryDetails
        }
        // Notification when the user has changed a city in his settings and when the saving is finished
        NotificationCenter.default.post(name: .newCity, object: nil)
    }
    
}

// MARK: UISearchBar
extension SearchCityViewController: UISearchBarDelegate {
    // When user adds a text in searchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !(searchBar.text?.isEmpty ?? true) {
            getCitiesList(city: searchBar.text!)
        }
    }
}


// MARK: UITableView
extension SearchCityViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Number of sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasOfCityTableView.count // Number of cells in each section
    }
    
    // Add cells with cities
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var city: City
        var cell: UITableViewCell
        
        cell = tableView.dequeueReusableCell(withIdentifier: cityCellIdentifier, for: indexPath)
        if datasOfCityTableView.count == 0 { return cell }
        
        // UI
        city = datasOfCityTableView[indexPath.row]
        cell.textLabel?.text = city.getLocalName(languageKeys: UserSettings.userLanguage)
        cell.detailTextLabel?.text = city.stateAndCountryDetails
        
        return cell
    }
}

extension SearchCityViewController: UITableViewDelegate {
    // When user clicks on a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Save the city that the user has clicked
        switch cityType {
            case .current:
                UserSettings.currentCity = datasOfCityTableView[indexPath.row]
            case .destination:
                UserSettings.destinationCity = datasOfCityTableView[indexPath.row]
        }
        // Get the country details of the city
        getCountryDetails(cityType: cityType)
        // Dismiss Screen
        dismiss(animated: true)
    }
}
