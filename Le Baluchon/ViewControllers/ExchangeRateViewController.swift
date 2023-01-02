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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // topBar
        topBar.delegate = self
        // tapGestureRecognizer
        tapGestureRecognizer.delegate = self
        // textfield
        currentAmount.delegate = self
        destinationAmount.delegate = self
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
    
    @IBAction func currentAmountAdded(_ sender: Any) {
        if let amount = currentAmount.text, let amountDouble = Double(amount) {
            getExchangeRateService(conversionFrom: .current, amount: amountDouble)
        }
    }
    
    @IBAction func destinationAmountAdded(_ sender: Any) {
        if let amount = destinationAmount.text, let amountDouble = Double(amount) {
            getExchangeRateService(conversionFrom: .destination, amount: amountDouble)
        }
    }
    
    private func setupUI() {
        // label
        screenDescription.text = "exchange.rate.description".localized()
        // currentCurrency
        currentAmount.placeholder = "amount".localized()
        // destinationCurrency
        destinationAmount.placeholder = "amount".localized()
    }
    
    private func setupUserSettings() {
        // currentCurrency
        currentAmount.title = UserSettings.currentCity?.getCurrency ?? "unknown.currency".localized()
        currentAmount.text = ""
        // destinationCurrency
        destinationAmount.title = UserSettings.destinationCity?.getCurrency ?? "unknown.currency".localized()
        destinationAmount.text = ""
    }
    
    private func dismissKeyBoard() {
        currentAmount.resignFirstResponder()
        destinationAmount.resignFirstResponder()
    }
    
    private func getExchangeRateService(conversionFrom cityType: CityType, amount: Double) {
        // Function making network call
        ExchangeRateService.shared.getExchangeRateService(conversionFrom: cityType, amount: amount) { error, exchangeRate in
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

