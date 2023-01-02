//
//  TranslationViewController.swift
//  Le Baluchon
//
//  Created by Maxime Point on 02/01/2023.
//

import Foundation
import UIKit

class TranslationViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var topBar: TopBarComponentView!
    @IBOutlet weak var screenDescription: UILabel!
    @IBOutlet weak var currentTranslation: TitledTextField!
    @IBOutlet weak var destinationTranslation: TitledTextField!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // topBar
        topBar.delegate = self
        // tapGestureRecognizer
        tapGestureRecognizer.delegate = self
        // textfield
        currentTranslation.delegate = self
        destinationTranslation.delegate = self
        // sliding the view depending on the keyboard
        self.view.bindToKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
        setupUserSettings()
    }
    
    @IBAction func dismissKeyBoardAfterGestureRecognizer(_ sender: Any) {
        dismissKeyBoard()
    }
    
    @IBAction func currentTranslationAdded(_ sender: Any) {
        if let text = currentTranslation.text {
            getTranslationService(translationFrom: .current, text: text)
        }
    }
    
    @IBAction func destinationTranslationAdded(_ sender: Any) {
        if let text = destinationTranslation.text {
            getTranslationService(translationFrom: .destination, text: text)
        }
    }
    
    private func setupUI() {
        // label
        screenDescription.text = "translation.description".localized()
        // currentCurrency
        currentTranslation.placeholder = "text.to.translate".localized()
        // destinationCurrency
        destinationTranslation.placeholder = "text.to.translate".localized()
    }
    
    private func setupUserSettings() {
        // currentCurrency
        currentTranslation.title = UserSettings.currentCity?.getLanguage ?? "unknown.language".localized()
        currentTranslation.text = ""
        // destinationCurrency
        destinationTranslation.title = UserSettings.destinationCity?.getLanguage ?? "unknown.language".localized()
        destinationTranslation.text = ""
    }
    
    private func dismissKeyBoard() {
        currentTranslation.resignFirstResponder()
        destinationTranslation.resignFirstResponder()
    }
    
    private func getTranslationService(translationFrom cityType: CityType, text: String) {
        //         Function making network call
        TranslationService.shared.getTranslationService(translationFrom: cityType, text: text) { error, translation in
            guard let translation = translation, error == nil else {
                let retry = UIAlertAction(title: "retry".localized(), style: .default) { _ in
                    self.getTranslationService(translationFrom: cityType, text: text)
                }
                let ok = UIAlertAction(title: "ok".localized(), style: .cancel) { _ in }
                self.alertUser(title: "error".localized(), message: error!.rawValue.localized(), actions: [retry, ok])
                return
            }
            switch cityType {
                case .current:
                    self.destinationTranslation.text = translation.resultText
                case .destination:
                    self.currentTranslation.text = translation.resultText
            }
        }
    }
    
}

// MARK: UITextField
extension TranslationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss KeyBoard
        return true
    }
    
}

// MARK: TOPBAR
extension TranslationViewController: ContainsTopBar {
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


