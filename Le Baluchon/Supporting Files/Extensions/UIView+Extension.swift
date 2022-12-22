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
}
