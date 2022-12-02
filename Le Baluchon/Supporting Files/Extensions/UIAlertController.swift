//
//  UIAlertController.swift
//  Le Baluchon
//
//  Created by Maxime Point on 02/12/2022.
//

import Foundation
import UIKit

// MARK: UIAlertController
extension UIViewController {
    func alertUser(title: String, message: String, actions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let actions = actions {
            actions.forEach { alert.addAction($0) }
        } else {
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        }
        present(alert, animated: true)
    }
}
