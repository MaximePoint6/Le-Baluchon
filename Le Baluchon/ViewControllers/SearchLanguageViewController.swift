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
    // Languages that will be added in the tableView
    private var datasOfLanguageTableView = [Languages]()
    /// Array of Language Enum with alphabetical sorting
    private var languages: [Languages] = (Languages.allCases.map { $0 }).sorted { $0.description < $1.description }
    
    // MARK: override function
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegate and dataSource
        self.searchBar.delegate = self
        self.languageTableView.dataSource = self
        self.languageTableView.delegate = self
        // add all languages by default in the datasOfLanguageTableView
        self.datasOfLanguageTableView = languages
        // UI
        setupUI()
    }
    
    // MARK: IBAction
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: private function
    private func setupUI() {
        cancelButton.setTitle("cancel".localized(), for: .normal)
        searchBar.placeholder = "language".localized()
    }
    
}

// MARK: UISearchBar
extension SearchLanguageViewController: UISearchBarDelegate {
    // When user adds a text in searchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !(searchBar.text?.isEmpty ?? true) {
            datasOfLanguageTableView.removeAll()
            // Adding the languages in datasOfLanguageTableView that match the user's search
            for language in languages where language.description.lowercased().contains(searchBar.text!.lowercased()) {
                datasOfLanguageTableView.append(language)
            }
        } else {
            self.datasOfLanguageTableView = languages
        }
        self.languageTableView.reloadData()
    }
}


// MARK: UITableView
extension SearchLanguageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Number of section
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasOfLanguageTableView.count // Number of cells in each section
    }
    
    // Add cells with languages
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var language: Languages
        var cell: UITableViewCell
        
        cell = tableView.dequeueReusableCell(withIdentifier: languageCellIdentifier, for: indexPath)
        if datasOfLanguageTableView.count == 0 { return cell }
        
        // UI
        language = datasOfLanguageTableView[indexPath.row]
        cell.textLabel?.text = language.description
        cell.detailTextLabel?.text = language.rawValue
        
        return cell
    }
}

extension SearchLanguageViewController: UITableViewDelegate {
    // When user clicks on a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Save the language that the user has clicked
        UserSettings.userLanguage = datasOfLanguageTableView[indexPath.row]
        // Notification when the user has changed a language in his settings
        NotificationCenter.default.post(name: .newLanguage, object: nil)
        // Dismiss Screen
        dismiss(animated: true)
    }
}
