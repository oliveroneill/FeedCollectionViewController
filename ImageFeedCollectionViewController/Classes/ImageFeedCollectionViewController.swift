//
//  ImageFeedCollectionViewController.swift
//  Pods
//
//  Created by Oliver ONeill on 17/12/2016.
//
//

import UIKit
import FeedCollectionViewController
import IDMPhotoBrowser

/**
 * Subclass this for an infinite scrolling image feed with image browser built
 * in. You must implement the corresponding image methods as opposed to
 * `FeedCollectionViewController`s methods.
 *
 * To use this class you must override: `getImageReuseIdentifier`,
 * `getImageCells` and `loadImageCell`
 */
open class ImageFeedCollectionViewController: FeedCollectionViewController, IDMPhotoDataSource {
    open func getImageReuseIdentifier(cell: ImageCellData) -> String {
        preconditionFailure("getImageReuseIdentifier must be overridden")
    }

    open func getImageCells(start:Int, callback: @escaping (([ImageCellData]) -> Void)) {
        preconditionFailure("getImageCells must be overridden")
    }

    open func loadImageCell(cellView: UICollectionViewCell, cell:ImageCellData) {
        preconditionFailure("loadImageCell must be overridden")
    }
    
    // MARK: FeedCollectionViewController methods

    open override func loadCell(cellView: UICollectionViewCell, cell: CellData) {
        if let cell = cell as? ImageCellData {
            loadImageCell(cellView: cellView, cell: cell)
        }
    }

    open override func getCells(start: Int, callback: @escaping (([CellData]) -> Void)) {
        getImageCells(start: start, callback: { data in
            callback(data)
        })
    }
    
    open override func getReuseIdentifier(cell: CellData) -> String {
        if let cell = cell as? ImageCellData {
            return getImageReuseIdentifier(cell: cell)
        }
        return super.getReuseIdentifier(cell: cell)
    }
    
    override open func didSelectCell(index:Int, cell:CellData) {
        let browser = IDMPhotoBrowser(dataSource: self)
        browser?.setInitialPageIndex(UInt(index))
        self.present(browser!, animated: true, completion: {})
    }
    
    // MARK: IDMPhotoDataSource methods
    public func getPhotos() -> [Any]! {
        return super.getPhotos()
    }
    
    public func loadMoreImages(_ browser: IDMBrowserDelegate?) {
        var cellBrowser:IDMCellBrowser? = nil
        if let b = browser {
            cellBrowser = IDMCellBrowser(browser: b)
        }
        super.loadMoreImages(browser: cellBrowser)
    }
}
