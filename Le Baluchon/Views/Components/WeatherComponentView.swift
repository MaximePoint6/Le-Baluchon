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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewInit()
    }
    
    // swiftlint:disable force_cast
    func viewInit() {
        let viewFromXib = Bundle.main.loadNibNamed("WeatherComponentView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    // swiftlint:enable force_cast
    
    func setupUI() {
        // code
    }
}
