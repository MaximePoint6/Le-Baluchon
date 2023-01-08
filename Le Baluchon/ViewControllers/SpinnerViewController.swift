//
//  SpinnerViewController.swift
//  Le Baluchon
//
//  Created by Maxime Point on 04/01/2023.
//

import Foundation
import UIKit

// Spinner screen during loading
class SpinnerViewController: UIViewController {

    var spinner = UIActivityIndicatorView(style: .large)

    // MARK: override function
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
