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

open class ColorFeedViewController: ImageFeedCollectionViewController {

    static let QUERY_SIZE = 20
    static var LENGTH = 50
    var loadingDelay = 1
    var imageDelay = 0.1

    var collectionLength = 0
    var hue = 0.0
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override open func getImageReuseIdentifier(cell: ImageCellData) -> String {
        return "ExampleCell"
    }
    
    override open func getImageCells(start: Int, callback: @escaping (([ImageCellData]) -> Void)) {
        // delay for 1 second in place of an actual network request
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(loadingDelay)) {
            // limit the cells to LENGTH
            if self.collectionLength > ColorFeedViewController.LENGTH {
                callback([])
                return
            }
            var cells:[ImageCellData] = []
            // will only return QUERY_SIZE at a time
            for _ in 0..<ColorFeedViewController.QUERY_SIZE {
                // increase hue slowly for each cell
                self.hue += 1.0/Double(ColorFeedViewController.LENGTH)
                let color = UIColor(hue: CGFloat(self.hue), saturation: 1, brightness: 1, alpha: 1)
                cells.append(ColorImageCellData(color: color, delay: self.imageDelay))
            }
            callback(cells)
            self.collectionLength += ColorFeedViewController.QUERY_SIZE
        }
    }
    
    open func refreshContent() {
        self.refresh()
    }
    
    override open func loadImageCell(cellView: UICollectionViewCell, cell: ImageCellData) {
        if let cellView = cellView as? ImageCollectionViewCell,
            let cell = cell as? ColorImageCellData {
            cellView.setImage(img: cell)
        }
    }
    
    open override func imageFailed(cell: ImageCellData, imageView: UIImageView) {
    }
}
