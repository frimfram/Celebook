//
//  Person.swift
//  Celebook
//
//  Created by Jean Ro on 2/26/18.
//  Copyright © 2018 Jean Ro. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit

public struct Celebrity: ArrayFromJson, Hashable {
    public var adult: Bool!
    public var id: Int!
    public var known_for: (tvShows: [KnownForTV]?, movies: [KnownForMovie]?)
    public var name: String!
    public var popularity: Double?
    public var profile_path: String?
    public var image: UIImage?
    public var squareImage: UIImage?
    
    public var movieCredits: PersonMovieCredits?

    public init(results json: JSON){
        adult = json["adult"].bool
        id = json["id"].int
        name = json["name"].string
        popularity = json["popularity"].double
        profile_path = json["profile_path"].string
        var tvShows =  [KnownForTV]()
        var movies = [KnownForMovie]()
        
        for knownFor in json["known_for"]{
            if knownFor.1["media_type"] == "tv"{
                tvShows.append(KnownForTV.init(results: knownFor.1))
            }else{
                movies.append(KnownForMovie.init(results: knownFor.1))
            }
        }
        known_for = (tvShows, movies)
    }
    
    init(id: Int, name: String, profilePath: String) {
        self.id = id
        self.name = name
        self.profile_path = profilePath
    }

    init?(data: [String: AnyObject]) {
        guard let id = data[TMDBConstants.TMDBResponseKeys.ID] as? Int,
            let profilePath = data[TMDBConstants.TMDBResponseKeys.ProfilePath] as? String,
            let name = data[TMDBConstants.TMDBResponseKeys.Name] as? String else {
                return nil
        }
        
        self.id = id
        self.profile_path = profilePath
        self.name = name
    }
    
    static func personsFromResults(_ results: [[String:AnyObject]]) -> [Celebrity] {
        var persons = [Celebrity]()
        for result in results {
            if let person = Celebrity(data:result) {
                persons.append(person)
            }
        }
        return persons
    }
    
    func printDebug() {
        print("id: \(id), name: \(name), profilePath: \(String(describing: profile_path))")
    }
    
    public var hashValue: Int {
        return id.hashValue ^ name.hashValue
    }
}

extension Celebrity: Equatable {
    static public func == (lhs: Celebrity, rhs: Celebrity) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}



