//
//  ColorCaptionFeedViewController.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 2/01/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import ImageFeedCollectionViewController

class ExampleSingleImageView: SingleImageView {
    override func setupCaption() {
        let label = UILabel(
            frame: CGRect(
                x: 10, y: 0, width: self.bounds.size.width-20,
                height: self.bounds.size.height
            )
        )
        label.textColor = .white
        label.text = cell.caption
        self.addSubview(label)
        let imgView = UIImageView(image: UIImage(color: .red))
        imgView.frame = CGRect(x: 5, y: 5, width: 10, height: 10)
        self.addSubview(imgView)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 10, height: 10)
    }
}

class ColorCaptionFeedViewController: ColorFeedViewController, PhotoBrowserDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        browserDelegate = self
    }

    public override func getSingleImageView(cell: ImageCellData) -> SingleImageView {
        return ExampleSingleImageView(cell: cell)
    }

    override func getImageCells(start: Int, callback: @escaping ImageCellDataCallback) {
        super.getImageCells(start: start, callback: { data, _ in
            for cell in data {
                cell.caption = "Test caption example"
            }
            callback(data, nil)
        })
    }
    
    public func setupToolbar(toolbar: UIToolbar, cell: ImageCellData) {
        let label = UILabel(
            frame: CGRect(
                x: 0, y: 0,
                width: UIScreen.main.bounds.width - 40, height: 40
            )
        )
        label.text = "Info"
        label.textAlignment = .right
        label.textColor = .white
        toolbar.setItems([UIBarButtonItem(customView: label)], animated: false)
    }

    func didShowPhoto(cell: ImageCellData) {}
    func imageDidFail(cell: ImageCellData, imageView: UIImageView) {}
}
