//
//  InitialViewController.swift
//  Celebook
//
//  Created by Jean Ro on 1/21/18.
//  Copyright © 2018 Jean Ro. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    var progressView: UIActivityIndicatorView?
    var progressLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addControls()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressView?.startAnimating()
        if let saved = TMDBClient.shared.getAllCelebrities() {
            TMDBClient.shared.selectedPersons = saved
            TMDBClient.shared.fetchCelebrityData(handler: { _ in })
            showCelebrityList()
        } else {
            TMDBClient.shared.fetchCelebrityData() { (error) in
                if error == nil {
                    self.showAddCelebrity()
                } else {
                    //show error message
                    let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func addControls() {
        progressView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        progressView?.center = view.center
        view.addSubview(progressView!)
        
        let frame = CGRect(x: view.center.x - 25, y: view.center.y - 100, width: 100, height: 50)
        progressLabel = UILabel(frame: frame)
        progressLabel?.text = "Loading"
        view.addSubview(progressLabel!)
    }
    
    func showAddCelebrity() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let addVC = storyBoard.instantiateViewController(withIdentifier: "AddCelebrityViewController")
        addVC.modalPresentationStyle = .fullScreen
        present(addVC, animated: false, completion: nil)
    }
    
    func showCelebrityList() {
        if let mainNavController = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") {
            present(mainNavController, animated: true, completion: nil)
        }
    }
}
