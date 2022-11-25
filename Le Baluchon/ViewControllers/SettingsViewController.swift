//
//  SettingsViewController.swift
//  Le Baluchon
//
//  Created by Maxime Point on 25/11/2022.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var language: UITextField!
    @IBOutlet weak var currentCity: UITextField!
    @IBOutlet weak var currentCityAutocompletion: UITableView!
    @IBOutlet weak var destinationCity: UITextField!
    @IBOutlet weak var destinationCityAutocompletion: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        currentCityAutocompletion.isHidden = true
        destinationCityAutocompletion.isHidden = true
    }

    @IBAction func getCurrentCitiesList(_ sender: Any) {
        currentCityAutocompletion.isHidden = false
        LocationService.shared.city = currentCity.text ?? ""
        LocationService.shared.getLocation { success, cities in
            guard let cities = cities, success == true else {
                self.presentAlert()
                return
            }
            print(cities)
            UserSettings.shared.currentCity = cities[0] // attention temporaire : à modifier car si il y a pas de valeur ca plante
        }
    }

    @IBAction func getDestinationCitiesList(_ sender: Any) {
        destinationCityAutocompletion.isHidden = false
        LocationService.shared.city = currentCity.text ?? ""
        LocationService.shared.getLocation { success, cities in
            guard let cities = cities, success == true else {
                self.presentAlert()
                return
            }
            print(cities)
            UserSettings.shared.destinationCity = cities[0]
        }
    }

}

extension SettingsViewController {
    func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The Locations download failed", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
}
