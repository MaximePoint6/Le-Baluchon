//
//  TopBarComponentView.swift
//  Le Baluchon
//
//  Created by Maxime Point on 16/12/2022.
//

import UIKit

class TopBarComponentView: UIView {

    @IBOutlet weak var userPicture: UIButton!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var userfirstName: UILabel!
    
    var delegate: ContainsTopBar?
    
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
    
    @IBAction func settingsButton(_ sender: Any) {
        delegate?.didClickSettings()
    }
    
    // swiftlint:disable force_cast
    func viewInit() {
        let viewFromXib = Bundle.main.loadNibNamed("TopBarComponentView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    // swiftlint:enable force_cast
    
    func setupUI() {
        userfirstName.text = UserSettings.shared.userName.capitalized
        
        if let userPicture = UserSettings.shared.userPicture {
            self.userPicture.setBackgroundImage(userPicture, for: UIControl.State.normal)
        } else {
            self.userPicture.setBackgroundImage(UIImage(systemName: "person.crop.circle.fill"),
                                                for: UIControl.State.normal)
        }
        // cornerRadius & border
        userPicture.layer.masksToBounds = true
        userPicture.layer.cornerRadius = 10
//        userPicture.layer.borderColor = UIColor.navyBlue.cgColor
//        userPicture.layer.borderWidth = 1.0
        
        let hour = Calendar.current.component(.hour, from: Date())
        if hour > 5 && hour <= 12 {
            helloLabel.text = "Good Morning"
        } else if hour > 12 && hour <= 18 {
            helloLabel.text = "Good Afternoon"
        } else {
            helloLabel.text = "Good Evening"
        }
    }
}
