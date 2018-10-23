//
//  TweetListViewController.swift
//  Celebook
//
//  Created by Jean Ro on 4/22/18.
//  Copyright © 2018 Jean Ro. All rights reserved.
//

import UIKit

class TweetListViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tweetList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetList.delegate = self
        tweetList.dataSource = self
    }
    @IBAction func logoutClicked(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func refreshClicked(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func addClicked(_ sender: UIBarButtonItem) {
    }
}

extension TweetListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension TweetListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
