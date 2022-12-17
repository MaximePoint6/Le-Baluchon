//
//  WeatherComponentView.swift
//  Le Baluchon
//
//  Created by Maxime Point on 16/12/2022.
//

import UIKit

class WeatherComponentView: UIView {
    
    @IBOutlet weak var skyLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var iconWeather: UIImageView!
    @IBOutlet weak var localDate: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewInit()
        setupUI()
    }
    
    // swiftlint:disable force_cast
    private func viewInit() {
        let viewFromXib = Bundle.main.loadNibNamed("WeatherComponentView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    // swiftlint:enable force_cast
    
    private func setupUI() {
        // cornerRadius & border
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
//        self.layer.borderColor = UIColor.black.cgColor
//        self.layer.borderWidth = 1.0
        
        // temperatureLabel
        temperatureLabel.adjustsFontSizeToFitWidth = true
        temperatureLabel.minimumScaleFactor = 0.5
        // cityNameLabel
        cityNameLabel.adjustsFontSizeToFitWidth = true
        cityNameLabel.minimumScaleFactor = 0.5
        // localDate
        localDate.adjustsFontSizeToFitWidth = true
        localDate.minimumScaleFactor = 0.5
        // skyLabel
        skyLabel.adjustsFontSizeToFitWidth = true
        skyLabel.minimumScaleFactor = 0.5
    }
}
