//
//  CustomImageCellData.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 21/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import ImageFeedCollectionViewController

public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

class ColorImageCellData: ImageCellData {
    private var imgView:UIImageView?
    private var image:UIImage?
    private var color:UIColor = .red
    private var loadingDelay: Double = 0.1
    
    convenience init(color: UIColor, delay: Double) {
        self.init(image: UIImage(color: color))
        self.color = color
        self.loadingDelay = delay
    }
    
    override func cellDidBecomeVisible() {
        // use 0.1 second delay instead of a network request
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(Int(loadingDelay*1000))) {
            self.image = UIImage(color: self.color)
            DispatchQueue.main.sync {
                self.imgView?.image = self.image
            }
        }
    }

    func setImageView(imageView:UIImageView) {
        self.imgView = imageView
        self.imgView?.image = self.image
    }
}
