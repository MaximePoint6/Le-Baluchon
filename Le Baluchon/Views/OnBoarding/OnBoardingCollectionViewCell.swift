//
//  OnBoardingCollectionViewCell.swift
//  Le Baluchon
//
//  Created by Maxime Point on 21/12/2022.
//

import UIKit

class OnBoardingCollectionViewCell: UICollectionViewCell {
    
    // this transforms OnBoarding CollectionViewCell into a string (this avoids throwing strings in the code)
    static let identifier = String(describing: OnBoardingCollectionViewCell.self)
    
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var slideTitleLabel: UILabel!
    @IBOutlet weak var slideDescriptionLabel: UILabel!
    
    func setup(_ slide: OnBoardingSlide) {
        slideImageView.image = slide.image
        slideTitleLabel.text = slide.title
        slideDescriptionLabel.text = slide.description
    }
    
}
