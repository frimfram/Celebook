//
//  TMDBObjects.swift
//  Celebook
//
//  Created by Jean Ro on 9/3/18.
//  Copyright © 2018 Jean Ro. All rights reserved.
//

import Foundation
import UIKit

open class DiscoverMDB: ArrayFromJson {
    open var adult: Bool!
    open var overview: String?
    open var popularity: Double?
    open var id: Int!
    open var backdrop_path: String?
    open var vote_average: Double?
    open var original_language: String?
    open var vote_count: Double?
    open var poster_path: String?
    open var genre_ids: [Int]?
    open var poster_image: UIImage?
    
    required public init(results: JSON){
        poster_path = results["poster_path"].string
        popularity = results["popularity"].double
        id = results["id"].int
        backdrop_path = results["backdrop_path"].string
        vote_average = results["vote_average"].double
        overview = results["overview"].string
        original_language = results["original_language"].string
        vote_count = results["vote_count"].double
        genre_ids = results["genre_ids"].arrayObject as? [Int]
        
    }
}

open class KnownForTV: DiscoverMDB, Equatable, Hashable {
    open var original_name: String?
    open var origin_country: [String]?
    open var first_air_date: String?
    open var name: String!
    open var media_type: String!
    
    required public init(results: JSON) {
        super.init(results: results)
        original_name = results["original_name"].string
        origin_country = results["origin_country"].arrayObject as? [String]
        first_air_date = results["first_air_date"].string
        name = results["name"].string
        media_type = results["media_type"].string
    }
    
    static public func == (lhs: KnownForTV, rhs: KnownForTV) -> Bool {
        return lhs.name == rhs.name
    }
    
    public var hashValue: Int {
        return name.hashValue ^ media_type.hashValue
    }
}

open class KnownForMovie: DiscoverMDB, Equatable, Hashable {
    open var original_title: String?
    open var release_date: String?
    open var title: String!
    open var video: Bool!
    open var media_type: String!
    
    required public init(results: JSON) {
        super.init(results: results)
        original_title = results["original_title"].string
        release_date = results["release_date"].string
        title = results["title"].string
        media_type = results["media_type"].string
    }
    
    static public func == (lhs: KnownForMovie, rhs: KnownForMovie) -> Bool {
        return lhs.title == rhs.title
    }
    
    public var hashValue: Int {
        return title.hashValue ^ media_type.hashValue
    }
}

public struct PageResultsMDB{
    
    public var page: Int!
    public var total_results: Int!
    public var total_pages: Int!
    
    public init(results: JSON){
        page = results["page"].int!
        total_results = results["total_results"].int!
        total_pages = results["total_pages"].int!
    }
}

public struct PersonMovieCredits{
    public var cast: [PersonMovieCast]
    public var id: Int!
    init(json: JSON){
        cast = PersonMovieCast.initialize(json: json["cast"])
        id = json["id"].int
    }
}

open class PersonMovieCast: ArrayFromJson {
    open var poster_path: String?
    open var credit_id: String!
    open var id: Int!
    open var character: String!
    open var adult: Bool!
    open var original_title: String!
    open var release_date: String!
    open var title: String!
    open var overview: String!
    open var poster_image: UIImage?
    
    required public init(results: JSON){
        poster_path = results["poster_path"].string
        credit_id = results["credit_id"].string
        id = results["id"].int
        character = results["character"].string
        adult = results["adult"].bool
        original_title = results["original_title"].string
        release_date = results["release_date"].string
        title = results["title"].string
        overview = results["overview"].string
    }
}
