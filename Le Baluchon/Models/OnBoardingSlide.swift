//
//  OnBoardingSlide.swift
//  Le Baluchon
//
//  Created by Maxime Point on 21/12/2022.
//

import Foundation
import UIKit

struct OnBoardingSlide {
    let title: String
    let description: String
    let image: UIImage
    let textFieldIsHidden: Bool
    let placeholderTextField: String?
    let searchCityButtonIsHidden: Bool
    let textSearchCityButton: String?
    
    static var slides: [OnBoardingSlide] {
        [
            OnBoardingSlide(title: "onBoardingSlide.title1".localized(),
                            description: "onBoardingSlide.description1".localized(),
                            image: UIImage(named: "OnBoardingSlide1")!,
                            textFieldIsHidden: true,
                            placeholderTextField: nil,
                            searchCityButtonIsHidden: true,
                            textSearchCityButton: nil),
            OnBoardingSlide(title: "onBoardingSlide.title2".localized(),
                            description: "onBoardingSlide.description2".localized(),
                            image: UIImage(named: "OnBoardingSlide2")!,
                            textFieldIsHidden: false,
                            placeholderTextField: "username".localized(),
                            searchCityButtonIsHidden: true,
                            textSearchCityButton: nil),
            OnBoardingSlide(title: String(format: "onBoardingSlide.title3".localized(), UserSettings.userName),
                            description: "onBoardingSlide.description3".localized(),
                            image: UIImage(named: "OnBoardingSlide3")!,
                            textFieldIsHidden: true,
                            placeholderTextField: nil,
                            searchCityButtonIsHidden: false,
                            textSearchCityButton: "search.city".localized()),
            OnBoardingSlide(title: String(format: "onBoardingSlide.title4".localized(), UserSettings.userName),
                            description: "onBoardingSlide.description4".localized(),
                            image: UIImage(named: "OnBoardingSlide4")!,
                            textFieldIsHidden: true,
                            placeholderTextField: nil,
                            searchCityButtonIsHidden: false,
                            textSearchCityButton: "search.city".localized())
        ]
    }
}
