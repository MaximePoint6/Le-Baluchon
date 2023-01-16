//
//  TopBarComponentView.swift
//  Le Baluchon
//
//  Created by Maxime Point on 16/12/2022.
//

import UIKit

class TopBarComponentView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var userPicture: UIButton!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var userfirstName: UILabel!
    
    // MARK: - Properties
    var delegate: ContainsTopBar?
    
    // MARK: - Override functions
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
    
    // MARK: - Actions
    @IBAction func settingsButton(_ sender: Any) {
        delegate?.didClickSettings()
    }
    
    // MARK: - Functions
    func viewInit() {
        let identifier = String(describing: TopBarComponentView.self)
        let viewFromXib = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
    func setupUI() {
        // userFisrtName
        userfirstName.text = UserSettings.userName.capitalized
        // userPicture
        if let userPicture = UserSettings.userPicture {
            self.userPicture.setImage(userPicture, for: .normal)
            self.userPicture.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        } else {
            self.userPicture.setBackgroundImage(UIImage(systemName: "person.crop.circle.fill"),
                                                for: UIControl.State.normal)
        }
        userPicture.layer.masksToBounds = true
        userPicture.layer.cornerRadius = 25
        // welcome / greeting message
        let hour = Calendar.current.component(.hour, from: Date())
        if hour > 5 && hour <= 12 {
            helloLabel.text = "good.morning,".localized()
        } else if hour > 12 && hour <= 18 {
            helloLabel.text = "good.afternoon,".localized()
        } else {
            helloLabel.text = "good.evening,".localized()
        }
    }
}
