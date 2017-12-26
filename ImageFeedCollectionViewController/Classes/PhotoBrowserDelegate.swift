//
//  PhotoBrowserDelegate.swift
//  ImageFeedCollectionViewController
//
//  Created by Oliver ONeill on 25/12/17.
//

import UIKit

public protocol PhotoBrowserDelegate: class {
    func imageDidFail(cell:ImageCellData, imageView:UIImageView)
    func setupToolbar(toolbar:UIToolbar, cell:ImageCellData)
    func didShowPhoto(cell:ImageCellData)
}
