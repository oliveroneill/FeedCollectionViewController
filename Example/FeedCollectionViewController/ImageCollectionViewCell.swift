//
//  ImageCollectionViewCell.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 21/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    func setImage(img: ColorImageCellData) {
        imageView.image = nil
        img.imageView = imageView
    }
}
