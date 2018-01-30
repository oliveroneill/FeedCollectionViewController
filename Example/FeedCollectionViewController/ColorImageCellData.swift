//
//  CustomImageCellData.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 21/12/2016.
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
    var image: UIImage? {
        didSet {
            self.imageDidChange?()
        }
    }
    var imageDidChange: (() -> ())?
    private var color: UIColor = .red
    private var loadingDelay: Double = 0.1

    convenience init(color: UIColor, delay: Double) {
        self.init(image: UIImage(color: color))
        self.color = color
        self.loadingDelay = delay
    }

    override func cellDidBecomeVisible() {
        // use 0.1 second delay instead of a network request
        if loadingDelay == 0 {
            setColor()
            return
        }
        let ms = Int(loadingDelay * 1000)
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(ms)) { [unowned self] in
            DispatchQueue.main.sync { [unowned self] in
                self.setColor()
            }
        }
    }

    func setColor() {
        self.image = UIImage(color: self.color)
    }
}
