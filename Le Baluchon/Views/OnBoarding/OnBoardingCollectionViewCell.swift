//
//  OnBoardingCollectionViewCell.swift
//  Le Baluchon
//
//  Created by Maxime Point on 21/12/2022.
//

import UIKit

class OnBoardingCollectionViewCell: UICollectionViewCell {
    
    // This transforms OnBoarding CollectionViewCell into a string (this avoids throwing strings in the code)
    static let identifier = String(describing: OnBoardingCollectionViewCell.self)
    
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var slideTitleLabel: UILabel!
    @IBOutlet weak var slideDescriptionLabel: UILabel!
    @IBOutlet weak var slideTextField: UITextField!
    @IBOutlet weak var slideSearchCityButton: UIButton!
    @IBOutlet weak var slideCityValidatedLabel: UILabel!
    
    var delegate: ContainsOnBoardingCollectionView?
    
    @IBAction func searchCityButtonClicked(_ sender: Any) {
        delegate?.didClickSearchCityButton()
    }
    
    func setup(_ slide: OnBoardingSlide) {
        slideImageView.image = slide.image
        slideTitleLabel.text = slide.title
        slideDescriptionLabel.text = slide.description
        
        // textField
        slideTextField.uiCustomization()
        slideTextField.isHidden = slide.textFieldIsHidden
        slideTextField.placeholder = slide.placeholderTextField
        if UserSettings.userName != "the.traveler".localized() {
            slideTextField.text = UserSettings.userName
        }
        
        // Button
        slideSearchCityButton.isHidden = slide.searchCityButtonIsHidden
        slideSearchCityButton.setTitle(slide.textSearchCityButton, for: .normal)
        
        // city Validated Label
        slideCityValidatedLabel.isHidden = true
    }
    
}
