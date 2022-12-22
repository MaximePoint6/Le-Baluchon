//
//  UIViewController+Extension.swift
//  Le Baluchon
//
//  Created by Maxime Point on 02/12/2022.
//

import Foundation
import UIKit

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
    
    static var identifier: String {
        return String(String(describing: self))
    }
    
    // swiftlint:disable force_cast
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: identifier) as! Self
    }
    // swiftlint:enable force_cast
}