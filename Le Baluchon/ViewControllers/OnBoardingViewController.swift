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
    
    var slides: [OnBoardingSlide] = []
    var currentPage = 0 {
        didSet {
            // The current page of the pageControl is equal to currentpage
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
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
        // slides
        slides = [
            OnBoardingSlide(title: "title 1", description: "Une description cool 1", image: UIImage(named: "Image")!),
            OnBoardingSlide(title: "title 2", description: "Une description cool 2", image: UIImage(named: "Image")!),
            OnBoardingSlide(title: "title 3", description: "Une description cool 3", image: UIImage(named: "Image")!)
        ]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToWeatherView" {
            _ = segue.destination as? SettingsViewController
        }
    }
    
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        if currentPage < slides.count - 1 {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
          // go to next page
            UserSettings.onBoardingScreenWasShown = true
            performSegue(withIdentifier: "segueToWeatherView", sender: nil)
        }
    }
    
}


extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingCollectionViewCell.identifier,
                                                         for: indexPath) as? OnBoardingCollectionViewCell {
            cell.setup(slides[indexPath.row])
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

