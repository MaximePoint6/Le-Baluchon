//
//  UIView+Extension.swift
//  Le Baluchon
//
//  Created by Maxime Point on 21/12/2022.
//

import Foundation
import UIKit

// swiftlint:disable force_cast

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
    
    // sliding the view depending on the keyboard
    func bindToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let beginningFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let deltaY = endFrame.origin.y - beginningFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0,
                                options: UIView.KeyframeAnimationOptions(rawValue: curve),
                                animations: {
            self.frame.origin.y += deltaY
        }, completion: nil)
    }

}

// swiftlint:enable force_cast
