//
//  UITextField+Extension.swift
//  Le Baluchon
//
//  Created by Maxime Point on 22/12/2022.
//

import Foundation
import UIKit


extension UITextField {
    func uiCustomization() {
        self.layer.masksToBounds = true
        // cornerRadius
        self.layer.cornerRadius = 10
        // border
        self.layer.borderColor = UIColor.navyBlue.cgColor
        self.layer.borderWidth = 2.0
        // padding
        self.leftView = UIView(frame: CGRectMake(0, 0, 20, 0))
        self.leftViewMode = UITextField.ViewMode.always
        self.rightView = UIView(frame: CGRectMake(0, 0, 20, 0))
        self.rightViewMode = UITextField.ViewMode.always
        // Placeholder
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                        attributes: [
                                                            NSAttributedString.Key.foregroundColor: UIColor.lightGray
                                                        ])
        
    }
}
