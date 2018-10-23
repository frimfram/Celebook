//
//  CelebrityCollectionViewCell.swift
//  Celebook
//
//  Created by Jean Ro on 8/25/18.
//  Copyright © 2018 Jean Ro. All rights reserved.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionView: UILabel!
    @IBOutlet weak var commentView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
    
    var photo: KnownForMovie? {
        didSet {
            if let photo = photo {
                imageView.image = photo.poster_image
                captionView.text = photo.title
                commentView.text = photo.overview
            }
        }
    }
}
