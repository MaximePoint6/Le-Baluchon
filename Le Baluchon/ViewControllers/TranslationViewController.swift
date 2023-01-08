//
//  TranslationViewController.swift
//  Le Baluchon
//
//  Created by Maxime Point on 02/01/2023.
//

import Foundation
import UIKit

class TranslationViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var currentTranslationView: CustomView!
    @IBOutlet weak var currentTranslationTextView: UITextView!
    @IBOutlet weak var destinationTranslationView: CustomView!
    @IBOutlet weak var destinationTranslationTextView: UITextView!
    @IBOutlet weak var topBar: TopBarComponentView!
    @IBOutlet weak var screenDescription: UILabel!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeField: UITextView?
    
    // MARK: override function
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegate
        topBar.delegate = self
        tapGestureRecognizer.delegate = self
        currentTranslationTextView.delegate = self
        destinationTranslationTextView.delegate = self
        // UI & User Settings
        uiSetup()
        textViewTitleSetup()
        // Notification when the user has changed a city or language or temperature unit in his settings.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.refreshAfterCityNotification(notification:)),
                                               name: .newCity,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.refreshAfterLanguageNotification(notification:)),
                                               name: .newLanguage,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        topBar.setupUI()
        // Notification for keyboard
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Notification for remove keyboard
        deregisterFromKeyboardNotifications()
    }
    
    // MARK: IBAction
    @IBAction func dismissKeyBoardAfterGestureRecognizer(_ sender: Any) {
        dismissKeyBoard()
    }
    
    // MARK: private function
    @objc private func refreshAfterLanguageNotification(notification: Notification) {
        uiSetup()
    }
    
    @objc private func refreshAfterCityNotification(notification: Notification) {
        currentTranslationTextView.text = nil
        destinationTranslationTextView.text = nil
        placeHolderSetup()
        textViewTitleSetup()
    }
    
    private func uiSetup() {
        screenDescriptionSetup()
        placeHolderSetup()
    }
    
    private func screenDescriptionSetup() {
        screenDescription.text = "translation.description".localized()
    }
    
    private func placeHolderSetup() {
        if currentTranslationTextView.text.isEmpty ||
            destinationTranslationTextView.text.isEmpty ||
            currentTranslationTextView.textColor == UIColor.placeholderText ||
            destinationTranslationTextView.textColor == UIColor.placeholderText {
            // Current translation
            currentTranslationTextView.text = "text.to.translate".localized()
            currentTranslationTextView.textColor = UIColor.placeholderText
            // Destination translation
            destinationTranslationTextView.text = "text.to.translate".localized()
            destinationTranslationTextView.textColor = UIColor.placeholderText
        }
        citiesLanguagesCheck()
    }
    
    /// Function to refresh the title of textView with the updated userSettings
    private func textViewTitleSetup() {
        currentTranslationView.title = UserSettings.currentCity?.getLanguage ?? "unknown.language".localized()
        destinationTranslationView.title = UserSettings.destinationCity?.getLanguage ?? "unknown.language".localized()
    }
    
    /// Checks if city languages are available for translation,
    /// if not, the function locks the edition of the textView and adds a message in the placeholder
    private func citiesLanguagesCheck() {
        currentTranslationTextView.isEditable = true
        destinationTranslationTextView.isEditable = true
        
        // If the language of the current or destination city is not available,
        // then we inform the user with a text in the textView and we lock the edition of the textView.
        if let currentCityLanguageCode = UserSettings.currentCity?.countryDetails?.languages?[0].iso6391,
           !Translation.availableLanguages.contains(currentCityLanguageCode.uppercased()) {
            currentTranslationTextView.text = "unavailable.language".localized()
            currentTranslationTextView.textColor = UIColor.placeholderText
            currentTranslationTextView.isEditable = false
            destinationTranslationTextView.text = "unavailable.translation".localized()
            destinationTranslationTextView.textColor = UIColor.placeholderText
            destinationTranslationTextView.isEditable = false
        } else if let destinationCityLanguageCode = UserSettings.destinationCity?.countryDetails?.languages?[0].iso6391,
            !Translation.availableLanguages.contains(destinationCityLanguageCode.uppercased()) {
            destinationTranslationTextView.text = "unavailable.language".localized()
            destinationTranslationTextView.textColor = UIColor.placeholderText
            destinationTranslationTextView.isEditable = false
            currentTranslationTextView.text = "unavailable.translation".localized()
            currentTranslationTextView.textColor = UIColor.placeholderText
            currentTranslationTextView.isEditable = false
        }
    }
    
    /// Dismiss Keyboard
    private func dismissKeyBoard() {
        currentTranslationTextView.resignFirstResponder()
        destinationTranslationTextView.resignFirstResponder()
    }
    
    
    /// Function performing another function that runs a network call in order to get the translation of a text.
    /// - Parameters:
    ///   - cityType: Indicate the city / language from which the translation must be done (current or destination).
    ///   - text: Text to translate.
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
            // UI update
            switch cityType {
                case .current:
                    self.destinationTranslationTextView.text = translation.resultText
                    self.destinationTranslationTextView.textColor = UIColor.darkGreen
                case .destination:
                    self.currentTranslationTextView.text = translation.resultText
                    self.currentTranslationTextView.textColor = UIColor.darkGreen
            }
        }
    }
    
}


// MARK: TOPBAR
extension TranslationViewController: ContainsTopBar {
    // Perform Segue
    func didClickSettings() {
        performSegue(withIdentifier: .segueToSettingsView, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == .segueToSettingsView {
            _ = segue.destination as? SettingsViewController
        }
    }
}


// MARK: TextView
extension TranslationViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeField = textView
        textView.text = ""
        textView.textColor = UIColor.darkGreen
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeField = nil
        if textView.text.isEmpty {
            placeHolderSetup()
        } else if textView.tag == 0, let text = textView.text {
            getTranslationService(translationFrom: .current, text: text)
        } else if textView.tag == 1, let text = textView.text {
            getTranslationService(translationFrom: .destination, text: text)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // When the user clicks the return button
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}


// MARK: KeyBoard
extension TranslationViewController {
    
    func registerForKeyboardNotifications() {
        // Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func deregisterFromKeyboardNotifications() {
        // Removing notifies on keyboard disappearing
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        self.scrollView.isScrollEnabled = true
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var shouldMoveViewUp = false
        // if active text field is not nil
        guard let activeField = activeField else {
            return
        }
        let bottomOfTextField = activeField.convert(activeField.bounds, to: self.view).maxY
        let topOfKeyboard = self.view.frame.height - keyboardSize.height
        
        // if the bottom of Textfield is below the top of keyboard, move up
        if bottomOfTextField > topOfKeyboard {
            shouldMoveViewUp = true
        }
        
        if shouldMoveViewUp {
            let heightTabBar = self.tabBarController?.tabBar.frame.height ?? 49.0
            self.view.frame.origin.y = 0 - keyboardSize.height + heightTabBar
            self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize.height, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
        
        self.view.frame.origin.y = 0
    }
}
