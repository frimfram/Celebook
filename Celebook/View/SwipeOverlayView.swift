//
//  SwipeOverlayView.swift
//  Celebook
//
//  Created by Jean Ro on 1/28/18.
//  Copyright © 2018 Jean Ro. All rights reserved.
//

import UIKit
import Koloda

class SwipeOverlayView: OverlayView {

    @IBOutlet weak var imageView: UIImageView!
    
    let skipImage = UIImage(named: "overlay_skip")
    let likeImage = UIImage(named: "overlay_like")
    
    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
            case .left? :
                imageView.image = skipImage
            case .right? :
                imageView.image = likeImage
            default:
                imageView.image = nil
            }
        }
    }

}
