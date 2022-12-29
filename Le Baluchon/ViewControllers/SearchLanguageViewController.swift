//
//  SearchLanguageViewController.swift
//  Le Baluchon
//
//  Created by Maxime Point on 19/12/2022.
//

import Foundation
import UIKit


class SearchLanguageViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var languageTableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    private let languageCellIdentifier = "LanguageCell"
    private var datasOfLanguageTableView = [Languages]()
    
    /// List of Language Enum with alphabetical sorting
    private var languagesList: [Languages] = (Languages.allCases.map { $0 }).sorted { $0.description < $1.description }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        // city table view
        self.languageTableView.dataSource = self
        self.languageTableView.delegate = self
        self.datasOfLanguageTableView = languagesList
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
        searchBar.placeholder = "language".localized()
    }
    
}

// MARK: UISearchBar
extension SearchLanguageViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !(searchBar.text?.isEmpty ?? true) {
            for language in languagesList where language.description.lowercased().contains(searchBar.text!.lowercased()) {
                datasOfLanguageTableView.removeAll()
                datasOfLanguageTableView.append(language)
            }
        } else {
            self.datasOfLanguageTableView = languagesList
        }
        self.languageTableView.reloadData()
    }
}


// MARK: UITableView
extension SearchLanguageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasOfLanguageTableView.count // number of cells in each section
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var language: Languages
        var cell: UITableViewCell
        
        cell = tableView.dequeueReusableCell(withIdentifier: languageCellIdentifier, for: indexPath)
        if datasOfLanguageTableView.count == 0 {
            return cell
        }
        language = datasOfLanguageTableView[indexPath.row]
        
        cell.textLabel?.text = language.description
        cell.detailTextLabel?.text = language.rawValue
        
        return cell
    }
}

extension SearchLanguageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserSettings.userLanguage = datasOfLanguageTableView[indexPath.row]
        dismiss(animated: true)
    }
}
