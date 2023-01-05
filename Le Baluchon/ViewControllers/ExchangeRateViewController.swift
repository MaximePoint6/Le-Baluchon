//
//  ExchangeRateViewController.swift
//  Le Baluchon
//
//  Created by Maxime Point on 01/01/2023.
//

import Foundation
import UIKit

class ExchangeRateViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var topBar: TopBarComponentView!
    @IBOutlet weak var screenDescription: UILabel!
    @IBOutlet weak var currentAmount: TitledTextField!
    @IBOutlet weak var destinationAmount: TitledTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegate
        topBar.delegate = self
        tapGestureRecognizer.delegate = self
        currentAmount.delegate = self
        destinationAmount.delegate = self
        // UI & User Settings
        setupUI()
        setupUserSettings()
        // Notification when the user has changed a city or language in his settings
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.refreshAfterCityNotification(notification:)),
                                               name: .newCity, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.refreshAfterLanguageNotification(notification:)),
                                               name: .newLanguage,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        topBar.setupUI()
        // Notification for keyboard
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Notification for remove keyboard
        deregisterFromKeyboardNotifications()
    }
    
    @IBAction func dismissKeyBoardAfterGestureRecognizer(_ sender: Any) {
        dismissKeyBoard()
    }
    
    @IBAction func currentAmountAdded(_ sender: Any) {
        guard let amount = currentAmount.text else {
            return
        }
        let correctAmount = amount.replacingOccurrences(of: ",", with: ".", options: .regularExpression)
        if let amountDouble = Double(correctAmount) {
            getExchangeRateService(conversionFrom: .current, amount: amountDouble)
        } else {
            destinationAmount.text = nil
            destinationAmount.placeholder = "amount".localized()
        }
    }
    
    @IBAction func destinationAmountAdded(_ sender: Any) {
        guard let amount = destinationAmount.text else {
            return
        }
        let correctAmount = amount.replacingOccurrences(of: ",", with: ".", options: .regularExpression)
        if let amountDouble = Double(correctAmount) {
            getExchangeRateService(conversionFrom: .destination, amount: amountDouble)
        } else {
            currentAmount.text = nil
            currentAmount.placeholder = "amount".localized()
        }
    }
    
    @objc private func refreshAfterLanguageNotification(notification: Notification) {
        setupUI()
    }
    
    @objc private func refreshAfterCityNotification(notification: Notification) {
        setupUserSettings()
        currentAmount.text = nil
        destinationAmount.text = nil
    }
    
    private func setupUI() {
        screenDescription.text = "exchange.rate.description".localized()
        currentAmount.placeholder = "amount".localized()
        destinationAmount.placeholder = "amount".localized()
    }
    
    private func setupUserSettings() {
        currentAmount.title = UserSettings.currentCity?.getCurrency ?? "unknown.currency".localized()
        destinationAmount.title = UserSettings.destinationCity?.getCurrency ?? "unknown.currency".localized()
    }
    
    private func dismissKeyBoard() {
        currentAmount.resignFirstResponder()
        destinationAmount.resignFirstResponder()
    }
    
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
        activeField = textField
        textField.text = ""
    }
    
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
        // Removing notifies on keyboard appearing
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
