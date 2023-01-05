//
//  SearchCityViewController.swift
//  Le Baluchon
//
//  Created by Maxime Point on 07/12/2022.
//

import Foundation
import UIKit


class SearchCityViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityTableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    private let cityCellIdentifier = "CityCell"
    private var datasOfCityTableView = [City]()
    var cityType: CityType = .current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        // city table view
        self.cityTableView.dataSource = self
        self.cityTableView.delegate = self
        // UI
        setupUI()
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func setupUI() {
        // cancelButton
        cancelButton.setTitle("cancel".localized(), for: .normal)
        // Searchbar
        searchBar.placeholder = "city".localized()
    }
    
    private func getCitiesList(city: String) {
        LocationService.shared.getLocation(city: city) { error, cities in
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
            // Notification when the user has changed a city in his settings
            NotificationCenter.default.post(name: .newCity, object: nil)
        }
    }
    
    private func saveCountryDetail(cityType: CityType, countryDetails: City.CountryDetails) {
        switch cityType {
            case .current:
                UserSettings.currentCity?.countryDetails = countryDetails
            case .destination:
                UserSettings.destinationCity?.countryDetails = countryDetails
        }
    }
    
}

// MARK: UISearchBar
extension SearchCityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !(searchBar.text?.isEmpty ?? true) {
            getCitiesList(city: searchBar.text!)
        } else { }
    }
}


// MARK: UITableView
extension SearchCityViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasOfCityTableView.count // number of cells in each section
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var city: City
        var cell: UITableViewCell
        
        cell = tableView.dequeueReusableCell(withIdentifier: cityCellIdentifier, for: indexPath)
        if datasOfCityTableView.count == 0 {
            return cell
        }
        city = datasOfCityTableView[indexPath.row]
        
        cell.textLabel?.text = city.getLocalName(languageKeys: UserSettings.userLanguage)
        cell.detailTextLabel?.text = city.stateAndCountryDetails
        
        return cell
    }
}

extension SearchCityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch cityType {
            case .current:
                UserSettings.currentCity = datasOfCityTableView[indexPath.row]
                getCountryDetails(cityType: cityType)
                dismiss(animated: true)
            case .destination:
                UserSettings.destinationCity = datasOfCityTableView[indexPath.row]
                getCountryDetails(cityType: cityType)
                dismiss(animated: true)
        }
    }
}
