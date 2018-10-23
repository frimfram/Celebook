//
//  MoviePoster.swift
//  Celebook
//
//  Created by Jean Ro on 10/7/18.
//  Copyright © 2018 Jean Ro. All rights reserved.
//

import Foundation
import UIKit

public struct MoviePoster {
    public let title: String
    public let overview: String
    public let image: UIImage
    
    init(title: String, overview: String, image: UIImage) {
        self.title = title
        self.overview = overview
        self.image = image
    }
}
