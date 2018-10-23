//
//  CelebrityCollectionViewController.swift
//  Celebook
//
//  Created by Jean Ro on 8/25/18.
//  Copyright © 2018 Jean Ro. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MoviesCollectionViewCell"

class MoviesCollectionViewController: UICollectionViewController {
    
    var celebrity: Celebrity? {
        didSet {
            guard let celebrity = self.celebrity else {
                self.moviePosters = []
                return
            }
            self.moviePosters =  TMDBClient.shared.posterImages[celebrity.id] ?? []
        }
    }
    
    var moviePosters: [MoviePoster] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = celebrity?.name
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviePosters.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MoviesCollectionViewCell
        let poster = moviePosters[indexPath.row]
        
        // Configure the cell
        cell.captionView.text = poster.title
        cell.commentView.text = poster.overview
        cell.imageView.image = poster.image
        return cell
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let previousTraitCollection = previousTraitCollection,
            traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass ||
                traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass else { return }
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.reloadData()
    }
}

extension MoviesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let image = moviePosters[indexPath.row].image
        let scale = image.size.height / image.size.width
        let height = width * scale
        return CGSize(width: width, height: height)
    }
}
