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
    
    var activeField: UITextField?
    
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
    
    
    // MARK: override function
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // tapGestureRecognizer
        tapGestureRecognizer.delegate = self
        self.collectionView?.addGestureRecognizer(tapGestureRecognizer)
        
        // button
        button.setTitle("next".localized(), for: .normal)
        
        // sliding the view depending on the keyboard
        self.view.bindToKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refresh()
    }
    
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
    @IBAction func nextButtonClicked(_ sender: Any) {
        dismissKeyBoard()
        if currentPage < OnBoardingSlide.slides.count - 1 {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            // go to next page
            UserSettings.onBoardingScreenWasShown = true
            performSegue(withIdentifier: .segueToWeatherView, sender: nil)
        }
    }
    
    @IBAction func dismissKeyBoardAfterGestureRecognizer(_ sender: Any) {
        dismissKeyBoard()
    }
    
    
    // MARK: private function
    private func refresh() {
        collectionView.reloadData()
    }
    
    private func dismissKeyBoard() {
        collectionView.endEditing(true)
    }
    
}




// MARK: UICollectionView
extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return OnBoardingSlide.slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingCollectionViewCell.identifier,
                                                         for: indexPath) as? OnBoardingCollectionViewCell {
            cell.setup(OnBoardingSlide.slides[indexPath.row])
            cell.delegate = self
            cell.slideTextField.delegate = self
            
            // CityValidatedLabel and button
            let checkmarkImage = NSTextAttachment()
            checkmarkImage.image = UIImage(systemName: "checkmark.circle")?.withTintColor(UIColor.mediumGreen)
            var myLabel = ""
            let fullString = NSMutableAttributedString(string: "")
            
            if indexPath.row == 2, UserSettings.currentCity != nil {
                myLabel = String(format: "city.validated.label".localized(), UserSettings.currentCity?.getLocalName(languageKeys: UserSettings.userLanguage) ?? "-")
                cell.slideCityValidatedLabel.isHidden = false
                cell.slideSearchCityButton.setTitle("search.other.city".localized(), for: .normal) // Button
            } else if indexPath.row == 3, UserSettings.destinationCity != nil {
                myLabel = String(format: "city.validated.label".localized(), UserSettings.destinationCity?.getLocalName(languageKeys: UserSettings.userLanguage) ?? "-")
                cell.slideCityValidatedLabel.isHidden = false
                cell.slideSearchCityButton.setTitle("search.other.city".localized(), for: .normal) // Button
            }
            
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
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
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
        // Save username in UserSettings
        if let username = textField.text {
            UserSettings.userName = username
        }
    }
}

