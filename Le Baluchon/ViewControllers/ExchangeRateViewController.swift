//
//  ExchangeRateViewController.swift
//  Le Baluchon
//
//  Created by Maxime Point on 01/01/2023.
//

import Foundation
import UIKit

class ExchangeRateViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Outlets
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var topBar: TopBarComponentView!
    @IBOutlet weak var screenDescription: UILabel!
    @IBOutlet weak var currentAmount: TitledTextField!
    @IBOutlet weak var destinationAmount: TitledTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    var activeField: UITextField?
    
    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegate
        topBar.delegate = self
        tapGestureRecognizer.delegate = self
        currentAmount.delegate = self
        destinationAmount.delegate = self
        // UI & User Settings
        uiSetup()
        textViewTitleSetup()
        // Notification when the user has changed a city or language in his settings.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.refreshAfterCityNotification(notification:)),
                                               name: .newCity, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.refreshAfterLanguageNotification(notification:)),
                                               name: .newLanguage,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        topBar.setupUI()
        // Add notification for keyboard
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove notification for remove keyboard
        deregisterFromKeyboardNotifications()
    }
    
    // MARK: - Actions
    @IBAction func dismissKeyBoardAfterGestureRecognizer(_ sender: Any) {
        dismissKeyBoard()
    }
    
    @IBAction func currentAmountAdded(_ sender: Any) {
        guard let amount = currentAmount.text else { return }
        // replace , with .
        let correctAmount = amount.replacingOccurrences(of: ",", with: ".", options: .regularExpression)
        if let amountDouble = Double(correctAmount) {
            getExchangeRateService(conversionFrom: .current, amount: amountDouble)
        } else {
            destinationAmount.text = nil
            destinationAmount.placeholder = "amount".localized()
        }
    }
    
    @IBAction func destinationAmountAdded(_ sender: Any) {
        guard let amount = destinationAmount.text else { return }
        // replace , with .
        let correctAmount = amount.replacingOccurrences(of: ",", with: ".", options: .regularExpression)
        if let amountDouble = Double(correctAmount) {
            getExchangeRateService(conversionFrom: .destination, amount: amountDouble)
        } else {
            currentAmount.text = nil
            currentAmount.placeholder = "amount".localized()
        }
    }
    
    // MARK: - Private functions
    @objc private func refreshAfterLanguageNotification(notification: Notification) {
        uiSetup()
    }
    
    @objc private func refreshAfterCityNotification(notification: Notification) {
        currentAmount.text = nil
        destinationAmount.text = nil
        textViewTitleSetup()
    }
    
    private func uiSetup() {
        // screenDescription
        screenDescription.text = "exchange.rate.description".localized()
        // placeholder
        currentAmount.placeholder = "amount".localized()
        destinationAmount.placeholder = "amount".localized()
    }
    
    /// Function to refresh the title of textView with the updated userSettings
    private func textViewTitleSetup() {
        currentAmount.title = UserSettings.currentCity?.getCurrency ?? "unknown.currency".localized()
        destinationAmount.title = UserSettings.destinationCity?.getCurrency ?? "unknown.currency".localized()
    }
    
    /// Dismiss Keyboard
    private func dismissKeyBoard() {
        currentAmount.resignFirstResponder()
        destinationAmount.resignFirstResponder()
    }
    
    /// Function performing another function that runs a network call in order to get the conversion of an amount.
    /// - Parameters:
    ///   - cityType: Indicate the city / country from which the conversion must be done (type: current or destination).
    ///   - amount: Amount to be converted.
    private func getExchangeRateService(conversionFrom cityType: CityType, amount: Double) {
        // Function making network call
        ExchangeRateService.shared.getExchangeRateService(conversionFrom: cityType,
                                                          amount: amount) { error, exchangeRate in
            guard let exchangeRate = exchangeRate, error == nil else {
                let retry = UIAlertAction(title: "retry".localized(), style: .default) { _ in
                    self.getExchangeRateService(conversionFrom: cityType, amount: amount)
                }
                let ok = UIAlertAction(title: "ok".localized(), style: .cancel) { _ in }
                self.alertUser(title: "error".localized(), message: error!.rawValue.localized(), actions: [retry, ok])
                return
            }
            // UI update
            switch cityType {
                case .current:
                    self.destinationAmount.text = exchangeRate.resultText
                case .destination:
                    self.currentAmount.text = exchangeRate.resultText
            }
        }
    }
    
}


// MARK: UITextField
extension ExchangeRateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss KeyBoard
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField // useful for the movement of the view when the keyboard appears
        textField.text = ""
    }
    
    // When user adds a amount in textField
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
}


// MARK: TOPBAR
extension ExchangeRateViewController: ContainsTopBar {
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


// MARK: KeyBoard
extension ExchangeRateViewController {
    
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
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as?
                                  NSValue)?.cgRectValue else {
            return
        }
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var shouldMoveViewUp = false
        // If active text field is not nil
        guard let activeField = activeField else {
            return
        }
        let bottomOfTextField = activeField.convert(activeField.bounds, to: self.view).maxY
        let topOfKeyboard = self.view.frame.height - keyboardSize.height
        
        // If the bottom of Textfield is below the top of keyboard, move up
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
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                                  as? NSValue)?.cgRectValue else {
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
