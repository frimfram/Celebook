//
//  ViewController.swift
//  Celebook
//
//  Created by Jean Ro on 1/21/18.
//  Copyright © 2018 Jean Ro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CelebrityListViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseIdentifier = "CelebrityTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func logoutClicked(_ sender: UIBarButtonItem) {
        logout()
    }
    
    @IBAction func refreshClicked(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func addClicked(_ sender: UIBarButtonItem) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let addVC = storyBoard.instantiateViewController(withIdentifier: "AddCelebrityViewController")
        addVC.modalPresentationStyle = .fullScreen
        present(addVC, animated: false, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateAddButton()
    }

    private func updateAddButton() {
        addButton.isEnabled = (TMDBClient.shared.selectedPersons.count < 10)
    }
    
    private func logout() {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
                present(vc, animated: true, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getImageURL(_ path: String) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = TMDBConstants.TMDB.ApiScheme
        urlComponents.host = TMDBConstants.TMDB.ImageHost
        urlComponents.path = TMDBConstants.TMDB.ImagePath + path
        return urlComponents.url!
    }
}

extension CelebrityListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TMDBClient.shared.selectedPersons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        let person = TMDBClient.shared.selectedPersons[indexPath.row]
        cell?.textLabel?.text = person.name

        if TMDBClient.shared.selectedPersons[indexPath.row].image == nil,
            let profilePath = TMDBClient.shared.selectedPersons[indexPath.row].profile_path {
            //profile image is missing so download
            if let profileImageData = try? Data(contentsOf: getImageURL(profilePath)) {
                if !profileImageData.isEmpty, let profileImage = UIImage(data: profileImageData) {
                    TMDBClient.shared.selectedPersons[indexPath.row].image = profileImage
                }
            }
        }

        if person.squareImage == nil, let originalImage = TMDBClient.shared.selectedPersons[indexPath.row].image {
            let itemSize = CGSize.init(width: 60, height: 60)
            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
            let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
            UIBezierPath.init(roundedRect: imageRect, cornerRadius: 30).addClip()
            originalImage.draw(in: imageRect)
            TMDBClient.shared.selectedPersons[indexPath.row].squareImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        cell?.imageView?.image = TMDBClient.shared.selectedPersons[indexPath.row].squareImage

        return cell!
    }
}

extension CelebrityListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (action, indexPath) in
            guard let strongSelf = self else { return }
            guard TMDBClient.shared.selectedPersons.count > indexPath.row else { return }
            TMDBClient.shared.selectedPersons.remove(at: indexPath.row)
            strongSelf.tableView.deleteRows(at: [indexPath], with: .fade)
            strongSelf.updateAddButton()
        }
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "MoviesCollectionViewController") as! MoviesCollectionViewController
        controller.celebrity = TMDBClient.shared.selectedPersons[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

