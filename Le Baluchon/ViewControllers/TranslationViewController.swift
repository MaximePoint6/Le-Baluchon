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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // topBar
        topBar.delegate = self
        // tapGestureRecognizer
        tapGestureRecognizer.delegate = self
        // textView
        currentTranslationTextView.delegate = self
        destinationTranslationTextView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
        setupUserSettings()
    }
    
    @IBAction func dismissKeyBoardAfterGestureRecognizer(_ sender: Any) {
        dismissKeyBoard()
    }
    
    private func setupUI() {
        // label
        screenDescription.text = "translation.description".localized()
        // currentCurrency
        if currentTranslationTextView.text.isEmpty {
            currentTranslationTextView.text = "text.to.translate".localized()
            currentTranslationTextView.textColor = UIColor.placeholderText
        }
        // destinationCurrency
        if destinationTranslationTextView.text.isEmpty {
            destinationTranslationTextView.text = "text.to.translate".localized()
            destinationTranslationTextView.textColor = UIColor.placeholderText
        }
    }
    
    private func setupUserSettings() {
        // currentView and currentTextView
        currentTranslationView.title = UserSettings.currentCity?.getLanguage ?? "unknown.language".localized()
        // destinationView and currentTextView
        destinationTranslationView.title = UserSettings.destinationCity?.getLanguage ?? "unknown.language".localized()
    }
    
    private func dismissKeyBoard() {
        currentTranslationTextView.resignFirstResponder()
        destinationTranslationTextView.resignFirstResponder()
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
                    self.destinationTranslationTextView.text = translation.resultText
                    self.destinationTranslationTextView.textColor = UIColor.lightGray
                case .destination:
                    self.currentTranslationTextView.text = translation.resultText
                    self.currentTranslationTextView.textColor = UIColor.lightGray
            }
        }
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


// MARK: TextView
extension TranslationViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
        if textView.textColor == UIColor.lightGray {
            textView.textColor = UIColor.darkGreen
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            currentTranslationTextView.text = "text.to.translate".localized()
            destinationTranslationTextView.text = "text.to.translate".localized()
            currentTranslationTextView.textColor = UIColor.lightGray
            destinationTranslationTextView.textColor = UIColor.lightGray
        } else if textView.tag == 0, let text = textView.text {
            getTranslationService(translationFrom: .current, text: text)
        } else if textView.tag == 1, let text = textView.text {
            getTranslationService(translationFrom: .destination, text: text)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}


