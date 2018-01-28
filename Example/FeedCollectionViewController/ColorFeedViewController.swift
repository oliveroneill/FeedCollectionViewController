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
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return NSString(format: "#%06x", rgb) as String
    }
}

open class ColorFeedViewController: ImageFeedCollectionViewController, ImageFeedPresenter, ImageFeedDataSource {
    private let querySize = 20

    // Cannot be private as these are changed for testing
    var length = 50
    var loadingDelay = 1
    var imageDelay = 0.1

    // internal counters
    private var collectionLength = 0
    private var hue = 0.0

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

    public func getImageCells(start: Int, callback: @escaping ImageCellDataCallback) {
        if loadingDelay == 0 {
            self.loadImages(start: start, callback: callback)
            return
        }
        // delay for 1 second in place of an actual network request
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(loadingDelay)) { [unowned self] in
            self.loadImages(start: start, callback: callback)
        }
    }

    func loadImages(start: Int, callback: @escaping ImageCellDataCallback) {
        // limit the cells to LENGTH
        if self.collectionLength > length {
            callback([], nil)
            return
        }
        var cells: [ImageCellData] = []
        // will only return query size at a time
        for _ in 0..<querySize {
            // increase hue slowly for each cell
            self.hue += 1.0 / Double(length)
            let color = UIColor(hue: CGFloat(self.hue), saturation: 1, brightness: 1, alpha: 1)
            cells.append(ColorImageCellData(color: color, delay: self.imageDelay))
        }
        callback(cells, nil)
        self.collectionLength += querySize
    }

    open func refreshContent() {
        self.refresh()
    }

    public func loadImageCell(cellView: UICollectionViewCell, cell: ImageCellData) {
        if let cellView = cellView as? ImageCollectionViewCell,
            let cell = cell as? ColorImageCellData {
            cellView.image = cell
        }
    }

    public func imageFailed(cell: ImageCellData, imageView: UIImageView) { }
}
