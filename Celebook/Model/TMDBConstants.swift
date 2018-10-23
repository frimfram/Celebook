//
//  TMDBConstants.swift
//  Celebook
//
//  Created by Jean Ro on 2/26/18.
//  Copyright © 2018 Jean Ro. All rights reserved.
//

import UIKit

struct TMDBConstants {
    
    // MARK: TMDB
    struct TMDB {
        static let ApiScheme = "https"
        static let ApiHost = "api.themoviedb.org"
        static let ApiPath = "/3"
        static let ImageHost = "image.tmdb.org"
        static let ImagePath = "/t/p/w500"
    }
    
    // MARK: TMDB Parameter Keys
    struct TMDBParameterKeys {
        static let ApiKey = "api_key"
        static let Page = "page"
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: TMDB Parameter Values
    struct TMDBParameterValues {
        static let ApiKey = "3ec18869090a1c912f7c6a649f6d1f5b"
    }
    
    // MARK: TMDB Response Keys
    struct TMDBResponseKeys {
        static let Name = "name"
        static let Title = "title"
        static let ID = "id"
        static let Page = "page"
        static let ProfilePath = "profile_path"
        static let PosterPath = "poster_path"
        static let StatusCode = "status_code"
        static let StatusMessage = "status_message"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Success = "success"
        static let UserID = "id"
        static let Results = "results"
    }
    
    // MARK: UI
    struct UI {
        static let LoginColorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).cgColor
        static let LoginColorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).cgColor
        static let GreyColor = UIColor(red: 0.702, green: 0.863, blue: 0.929, alpha:1.0)
        static let BlueColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
    }
}
