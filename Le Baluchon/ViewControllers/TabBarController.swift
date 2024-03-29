//
//  TabBarController.swift
//  Le Baluchon
//
//  Created by Maxime Point on 02/01/2023.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - Override functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    // MARK: - Private functions
    private func setupUI() {
        tabBar.items?[0].title = "weather".localized()
        tabBar.items?[1].title = "exchange.rate".localized()
        tabBar.items?[2].title = "translation".localized()
    }
    
}
