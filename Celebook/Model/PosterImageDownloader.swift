//
//  PosterImageDownloader.swift
//  Celebook
//
//  Created by Jean Ro on 10/6/18.
//  Copyright © 2018 Jean Ro. All rights reserved.
//

import Foundation
import UIKit

class PendingOperations {
    lazy var downloadsInProgress: [Int: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Photo Download Queue"
        queue.maxConcurrentOperationCount = 3
        return queue
    }()
}

class PosterImageDownloader: Operation {
    var celebrity: Celebrity
    
    init?(_ celebrity: Celebrity) {
        self.celebrity = celebrity
    }
    
    override func main() {
        if isCancelled {
            return
        }
        downloadMovieCredits()
    }
    
    func downloadMovieCredits() {
        if isCancelled {
            return
        }
        if celebrity.image == nil, let profilePath = celebrity.profile_path {
            //profile image is missing so download
            if let profileImageData = try? Data(contentsOf: getImageURL(profilePath)) {
                if !profileImageData.isEmpty, let profileImage = UIImage(data: profileImageData) {
                    celebrity.image = profileImage
                }
            }
        }
        TMDBClient.shared.fetchMovies(for: celebrity.id) { (movieCredits, error) in
            if let error = error {
                //error fetching the movies
                print("Error fetching movie credits for \(String(describing: self.celebrity.id)), error: \(error)")
            }
            if let credit = movieCredits {
                self.celebrity.movieCredits = credit
                self.downloadPostersFromMovieCredits()
            }
        }
    }
    
    func downloadPostersFromMovieCredits() {
        guard let credits = self.celebrity.movieCredits else {
            return
        }
        for credit in credits.cast {
            if isCancelled {
                return
            }
            guard let path = credit.poster_path else { continue }
            guard let imageData = try? Data(contentsOf: getImageURL(path)) else { continue }
            if !imageData.isEmpty {
                if let posterImage = UIImage(data: imageData) {
                    if TMDBClient.shared.posterImages[celebrity.id] == nil {
                        TMDBClient.shared.posterImages[celebrity.id] = [MoviePoster]()
                    }
                    let poster = MoviePoster(title: credit.title, overview: credit.overview, image: posterImage)
                    TMDBClient.shared.posterImages[celebrity.id]?.append(poster)
                }
            }
        }
    }
    
    func getImageURL(_ path: String) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = TMDBConstants.TMDB.ApiScheme
        urlComponents.host = TMDBConstants.TMDB.ImageHost
        urlComponents.path = TMDBConstants.TMDB.ImagePath + path
        return urlComponents.url!
    }
}
