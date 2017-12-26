//
//  CustomImageViewController.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 21/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import ImageFeedCollectionViewController

extension UIColor {
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
}

open class ColorFeedViewController: ImageFeedCollectionViewController, ImageFeedPresenter, ImageFeedDataSource {

    static let QUERY_SIZE = 20
    static var length = 50
    var loadingDelay = 1
    var imageDelay = 0.1

    var collectionLength = 0
    var hue = 0.0

    override open func viewDidLoad() {
        super.viewDidLoad()
        imageFeedSource = self
        imageFeedPresenter = self
    }

    public func getImageReuseIdentifier(cell: ImageCellData) -> String {
        return "ExampleCell"
    }

    public func getSingleImageView(cell: ImageCellData) -> SingleImageView {
        // This is a slight quirk in Swift, in order for
        // `ColorCaptionFeedCollectionViewController` to override the default
        // implementation of `getSingleImageView`, we need to call it here first
        // See: https://team.goodeggs.com/overriding-swift-protocol-extension-default-implementations-d005a4428bda
        return self.getSingleImageView(cell: cell)
    }

    public func getImageCells(start: Int, callback: @escaping (([ImageCellData]) -> Void)) {
        if loadingDelay == 0 {
            self.loadImages(start: start, callback: callback)
            return
        }
        // delay for 1 second in place of an actual network request
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(loadingDelay)) {
            self.loadImages(start: start, callback: callback)
        }
    }

    func loadImages(start: Int, callback: @escaping (([ImageCellData]) -> Void)) {
        // limit the cells to LENGTH
        if self.collectionLength > ColorFeedViewController.length {
            callback([])
            return
        }
        var cells:[ImageCellData] = []
        // will only return QUERY_SIZE at a time
        for _ in 0..<ColorFeedViewController.QUERY_SIZE {
            // increase hue slowly for each cell
            self.hue += 1.0/Double(ColorFeedViewController.length)
            let color = UIColor(hue: CGFloat(self.hue), saturation: 1, brightness: 1, alpha: 1)
            cells.append(ColorImageCellData(color: color, delay: self.imageDelay))
        }
        callback(cells)
        self.collectionLength += ColorFeedViewController.QUERY_SIZE
    }

    open func refreshContent() {
        self.refresh()
    }

    public func loadImageCell(cellView: UICollectionViewCell, cell: ImageCellData) {
        if let cellView = cellView as? ImageCollectionViewCell,
            let cell = cell as? ColorImageCellData {
            cellView.setImage(img: cell)
        }
    }

    public func imageFailed(cell: ImageCellData, imageView: UIImageView) {}
}
