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
    @IBOutlet weak var firstNameUser: UILabel!
    
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
        // code
    }
    

}
