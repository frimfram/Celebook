//
//  AddCelebrityViewController.swift
//  Celebook
//
//  Created by Jean Ro on 1/21/18.
//  Copyright © 2018 Jean Ro. All rights reserved.
//

import UIKit
import Koloda
import Kingfisher

class AddCelebrityViewController: UIViewController {

    @IBOutlet weak var kolodaSwipeView: KolodaView!

    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaSwipeView.dataSource = self
        kolodaSwipeView.delegate = self
    }
    
    @IBAction func onSkipClicked(_ sender: Any) {
        kolodaSwipeView.swipe(.left)
    }
    
    @IBAction func onLikeClicked(_ sender: Any) {
        kolodaSwipeView.swipe(.right)
    }
    
    func tmdbImageURL(_ path: String) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = TMDBConstants.TMDB.ApiScheme
        urlComponents.host = TMDBConstants.TMDB.ImageHost
        urlComponents.path = TMDBConstants.TMDB.ImagePath + path
        return urlComponents.url!
    }
    
    func checkForLimit() -> Bool {
        return (TMDBClient.shared.selectedPersons.count >= 10)
    }
    
    func navigateToMain() {
        if let mainNavController = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") {
            present(mainNavController, animated: true, completion: nil)
        }
    }
}

extension AddCelebrityViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        TMDBClient.shared.fetchCelebrityData() { error in
            if error == nil {
                koloda.reloadData()
            }
        }
    }
    
    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        if (checkForLimit()) {
            navigateToMain()
        }
        let fetchedCount = TMDBClient.shared.persons.count
        if (fetchedCount - index) < 10 {
            TMDBClient.shared.fetchCelebrityData() { error in
                if error == nil {
                    koloda.reloadData()
                }
            }
        }
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        let fetchedCount = TMDBClient.shared.persons.count
        if (fetchedCount - index) < 10 {
            TMDBClient.shared.fetchCelebrityData() { error in
                if error == nil {
                    koloda.reloadData()
                }
            }
        }
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if (direction == .right) {
            TMDBClient.shared.addPerson(TMDBClient.shared.persons[index])
        }
    }
}

extension AddCelebrityViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return TMDBClient.shared.persons.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let url = tmdbImageURL(TMDBClient.shared.persons[index].profile_path!)
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.kf.indicatorType = .activity
        view.layer.cornerRadius = 10
        view.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: { receivedSize, totalSize in
            //print("\(index+1): \(receivedSize) / \(totalSize)")
        }, completionHandler: { image, error, cacheType, imageURL in
            TMDBClient.shared.persons[index].image = image
            //print("\(index+1): Finished")
        })
        return view
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
    
}
