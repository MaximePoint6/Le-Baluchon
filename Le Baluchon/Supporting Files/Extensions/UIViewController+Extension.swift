//
//  UIViewController+Extension.swift
//  Le Baluchon
//
//  Created by Maxime Point on 02/12/2022.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// Function displaying a user alert on the screen.
    /// - Parameters:
    ///   - title: User Alert Title
    ///   - message: User alert message
    ///   - actions: User alert actions as an array of UIAlertAction
    ///   - preferredStyle: Style of UIAlertController, by default .alert
    func alertUser(title: String,
                   message: String,
                   actions: [UIAlertAction]? = nil,
                   preferredStyle: UIAlertController.Style = .alert) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        if let actions = actions {
            actions.forEach { alert.addAction($0) }
        } else {
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        }
        present(alert, animated: true)
    }
    
    /// Transforms the class name of the ViewController into an Identifier (of type String).
    static var viewControllerIdentifier: String {
        return String(describing: self)
    }
    
    /// Function to instantiate a ViewController
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: viewControllerIdentifier) as! Self
    }
    
    /// Function performing a performSegue with a SegueIdentifier (enum)
    func performSegue(withIdentifier identifier: SegueIdentifiers, sender: Any?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
}
