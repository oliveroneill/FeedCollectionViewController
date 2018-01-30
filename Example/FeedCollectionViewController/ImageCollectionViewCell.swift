//
//  ImageCollectionViewCell.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 21/12/2016.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    var image: ColorImageCellData? {
        didSet {
            let imageDidChange = { [unowned self] in
                self.imageView.image = self.image?.image
            }
            image?.imageDidChange = imageDidChange
            imageDidChange()
        }
    }
}
