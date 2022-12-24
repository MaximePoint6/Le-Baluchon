//
//  OnBoardingViewController.swift
//  Le Baluchon
//
//  Created by Maxime Point on 20/12/2022.
//

import UIKit

class OnBoardingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var button: UIButton!
    
    private let segueFromOnBoardingToSearchCity = "segueFromOnBoardingToSearchCity"
    private let segueToWeatherView = "segueToWeatherView"
    
    private var currentPage = 0 {
        didSet {
            // The current page of the pageControl is equal to currentpage
            pageControl.currentPage = currentPage
            refresh()
            if currentPage == OnBoardingSlide.slides.count - 1 {
                button.setTitle("get.started".localized(), for: .normal)
            } else {
                button.setTitle("next".localized(), for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        // button
        button.setTitle("next".localized(), for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToWeatherView {
            _ = segue.destination as? SettingsViewController
        } else if segue.identifier == segueFromOnBoardingToSearchCity {
            let VC = segue.destination as? SearchCityViewController
            let cityType = sender as? CityType
            VC?.cityType = cityType ?? .current
        }
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        if currentPage < OnBoardingSlide.slides.count - 1 {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            // go to next page
            UserSettings.onBoardingScreenWasShown = true
            performSegue(withIdentifier: segueToWeatherView, sender: nil)
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingCollectionViewCell.identifier,
                                                         for: IndexPath(item: 1, section: 1)) as? OnBoardingCollectionViewCell {
            cell.slideTextField.resignFirstResponder()
        }
    }
    
    private func refresh() {
        collectionView.reloadData()
    }
    
}


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
        // Width of scrollview on screen
        let width = scrollView.frame.width
        // Current position divided by width of the scrollView, we get the page number
        currentPage = Int(scrollView.contentOffset.x/width)
    }
}



extension OnBoardingViewController: ContainsOnBoardingCollectionView {
    // Segue
    func didClickSearchCityButton() {
        if currentPage == 2 {
            performSegue(withIdentifier: segueFromOnBoardingToSearchCity, sender: CityType.current)
        } else if currentPage == 3 {
            performSegue(withIdentifier: segueFromOnBoardingToSearchCity, sender: CityType.destination)
        } else { }
    }
    
    func editedTextField() {
        // Save username in UserSettings
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OnBoardingCollectionViewCell.identifier,
            for: IndexPath(item: 1, section: 0)) as? OnBoardingCollectionViewCell else {
            return
        }
        if let username = cell.slideTextField.text {
            UserSettings.userName = username
        }
    }
}

extension OnBoardingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

