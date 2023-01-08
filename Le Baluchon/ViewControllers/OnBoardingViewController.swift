//
//  OnBoardingViewController.swift
//  Le Baluchon
//
//  Created by Maxime Point on 20/12/2022.
//

import UIKit

class OnBoardingViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var button: UIButton!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    /// Returns the current page / slide of OnBoarding Screen, and changes the button title of the slide
    private var currentPage = 0 {
        didSet {
            // The current page of the pageControl is equal to currentpage
            pageControl.currentPage = currentPage
            if currentPage == OnBoardingSlide.slides.count - 1 {
                button.setTitle("get.started".localized(), for: .normal)
            } else {
                button.setTitle("next".localized(), for: .normal)
            }
        }
    }
    
    /// Checks if the information requested in all the slides is filled in, returns true or false
    private var slideInformationIsOk: Bool {
        if UserSettings.currentCity != nil &&
            UserSettings.destinationCity != nil &&
            UserSettings.userName != "" &&
            UserSettings.userName != "the.traveler".localized() {
            return true
        } else {
            return false
        }
    }
    
    
    // MARK: override function
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegate
        collectionView.delegate = self
        collectionView.dataSource = self
        tapGestureRecognizer.delegate = self
        
        // TapGestureRecognizer
        self.collectionView?.addGestureRecognizer(tapGestureRecognizer)
        
        // Button title
        button.setTitle("next".localized(), for: .normal)
        
        // Sliding the view when the keyboard appears
        self.view.bindToKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    // Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == .segueToWeatherView {
            _ = segue.destination as? SettingsViewController
        } else if segue.identifier == .segueFromOnBoardingToSearchCity {
            let VC = segue.destination as? SearchCityViewController
            let cityType = sender as? CityType
            VC?.cityType = cityType ?? .current
        }
    }
    
    
    // MARK: IBAction
    /// When the user click on next button
    @IBAction func nextButtonClicked(_ sender: Any) {
        dismissKeyBoard()
        if currentPage < OnBoardingSlide.slides.count - 1 {
            // User is not on last slide of onBoarding Screen :
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            if slideInformationIsOk {
                // If the information requested in all the slides is filled :
                UserSettings.onBoardingScreenWasShown = true
                performSegue(withIdentifier: .segueToWeatherView, sender: nil)
            } else {
                alertUser(title: "alert.onBoarding.title".localized(), message: "alert.onBoarding.message".localized())
            }
        }
    }
    
    /// When the keyboard is displayed and the user taps elsewhere on the screen, the keyboard disappears.
    @IBAction func dismissKeyBoardAfterGestureRecognizer(_ sender: Any) {
        dismissKeyBoard()
    }
    
    
    // MARK: private function
    /// Refresh the collection View with its new data
    private func refresh() {
        collectionView.reloadData()
    }
    
    /// Dismiss Keyboard
    private func dismissKeyBoard() {
        collectionView.endEditing(true)
    }
    
}




// MARK: UICollectionView
extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return OnBoardingSlide.slides.count
    }
    
    // creation of slides
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingCollectionViewCell.identifier,
                                                         for: indexPath) as? OnBoardingCollectionViewCell {
            // Setup
            cell.setup(OnBoardingSlide.slides[indexPath.row])
            
            // Delegate
            cell.delegate = self
            cell.slideTextField.delegate = self
            
            // CityValidatedLabel and Button
            let checkmarkImage = NSTextAttachment()
            checkmarkImage.image = UIImage(systemName: "checkmark.circle")?.withTintColor(UIColor.darkGreen)
            var myLabel = ""
            let fullString = NSMutableAttributedString(string: "")
            
            // If currentCity and destination is not nil, then we change the UI
            if indexPath.row == 2, UserSettings.currentCity != nil {
                myLabel = String(format: "city.validated.label".localized(),
                                 UserSettings.currentCity?.getLocalName(languageKeys: UserSettings.userLanguage) ?? "-")
                cell.slideCityValidatedLabel.isHidden = false
                cell.slideSearchCityButton.setTitle("search.other.city".localized(), for: .normal)
            } else if indexPath.row == 3, UserSettings.destinationCity != nil {
                myLabel = String(format: "city.validated.label".localized(),
                                 UserSettings.destinationCity?.getLocalName(languageKeys: UserSettings.userLanguage) ?? "-")
                cell.slideCityValidatedLabel.isHidden = false
                cell.slideSearchCityButton.setTitle("search.other.city".localized(), for: .normal)
            }
            
            // Add the text in slideCityValidatedLabel
            fullString.append(NSAttributedString(attachment: checkmarkImage))
            fullString.append(NSAttributedString(string: myLabel))
            cell.slideCityValidatedLabel.attributedText = fullString
            
            return cell
        }
        return UICollectionViewCell()
    }
}

extension OnBoardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Return the size of the collectionView
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    // When user scrolls
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        dismissKeyBoard()
        // Width of scrollview on screen
        let width = scrollView.frame.width
        // Current position divided by width of the scrollView, we get the page number
        currentPage = Int(scrollView.contentOffset.x/width)
    }
}



// MARK: ContainsOnBoardingCollectionView
extension OnBoardingViewController: ContainsOnBoardingCollectionView {
    // PerformSegue
    func didClickSearchCityButton() {
        if currentPage == 2 {
            performSegue(withIdentifier: .segueFromOnBoardingToSearchCity, sender: CityType.current)
        } else if currentPage == 3 {
            performSegue(withIdentifier: .segueFromOnBoardingToSearchCity, sender: CityType.destination)
        } else { }
    }
}


// MARK: UITextField
extension OnBoardingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss KeyBoard
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let username = textField.text {
            UserSettings.userName = username // Save username in UserSettings
            refresh() // Refresh so that the following slides update
        }
    }
}

