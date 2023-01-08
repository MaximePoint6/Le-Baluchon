//
//  UIView+Extension.swift
//  Le Baluchon
//
//  Created by Maxime Point on 21/12/2022.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
    
    /// Function activating the reception of notifications when a keyboard appears, and executing another function to slide the view above the keyboard.
    func bindToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    /// Function deactivating the reception of notifications when a keyboard appears.
    func unbindToKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    /// Sliding the view depending on the keyboard
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
