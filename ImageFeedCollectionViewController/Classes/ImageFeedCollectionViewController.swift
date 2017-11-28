//
//  ImageFeedCollectionViewController.swift
//  Pods
//
//  Created by Oliver ONeill on 17/12/2016.
//
//

import UIKit
import FeedCollectionViewController
import OOPhotoBrowser

/**
 * Subclass this for an infinite scrolling image feed with image browser built
 * in. You must implement the corresponding image methods as opposed to
 * `FeedCollectionViewController`s methods.
 *
 * To use this class you must override: `getImageReuseIdentifier`,
 * `getImageCells` and `loadImageCell`
 */
open class ImageFeedCollectionViewController: FeedCollectionViewController, IDMPhotoDataSource, IDMPhotoBrowserDelegate {
    private var browser:IDMPhotoBrowser?
    open func getImageReuseIdentifier(cell: ImageCellData) -> String {
        preconditionFailure("getImageReuseIdentifier must be overridden")
    }

    /*
     * NOTE: `callback` uses the main thread, so `callback` must be called from
     * a different thread. It's assumed that `getCells` is an asynchronous call.
     */
    open func getImageCells(start:Int, callback: @escaping (([ImageCellData]) -> Void)) {
        preconditionFailure("getImageCells must be overridden")
    }

    open func loadImageCell(cellView: UICollectionViewCell, cell:ImageCellData) {
        preconditionFailure("loadImageCell must be overridden")
    }
    
    open func getSingleImageView(cell:ImageCellData) -> SingleImageView {
        return SingleImageView(cell: cell)
    }

    // Add new views to the photo browser that will hide on tap
    open func addToolbarView(view: UIView) {
        browser?.addToolbarView(view)
    }

    // Override this to receive alerts when an image fails to load while in
    // IDMPhotoBrowser
    open func imageFailed(cell:ImageCellData, imageView:UIImageView) {}

    open func setupToolbar(toolbar:UIToolbar, cell:ImageCellData) {}
    
    open func didShowPhoto(cell:ImageCellData) {}

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
        guard let browser = IDMPhotoBrowser(dataSource: self) else {
            return
        }
        browser.setInitialPageIndex(UInt(index))
        browser.delegate = self
        self.browser = browser
        self.present(browser, animated: true, completion: {})
    }

    // MARK: IDMPhotoDataSource methods
    public func photo(at index: UInt) -> IDMPhotoProtocol? {
        let cells = super.getCurrentCells()
        return cells[Int(index)] as? ImageCellData
    }

    public func numberOfPhotos() -> Int32 {
        return Int32(super.getCurrentCells().count)
    }
    
    public func loadMoreImages(_ browser: IDMBrowserDelegate?) {
        var cellBrowser:IDMCellBrowser? = nil
        if let b = browser {
            cellBrowser = IDMCellBrowser(browser: b)
        }
        super.loadMoreImages(browser: cellBrowser)
    }
    
    // MARK: IDMPhotoBrowserDelegate methods
    public func photoBrowser(_ photoBrowser: IDMPhotoBrowser, captionViewForPhotoAt index: UInt) -> IDMCaptionView? {
        if let cell = super.getCurrentCells()[Int(index)] as? ImageCellData {
            if cell.caption != nil {
                return getSingleImageView(cell: cell)
            }
        }
        return nil
    }
    
    public func photoBrowser(_ photoBrowser: IDMPhotoBrowser, imageFailed index: UInt, imageView: IDMTapDetectingImageView) {
        if let cell = super.getCurrentCells()[Int(index)] as? ImageCellData {
            imageFailed(cell: cell, imageView:imageView)
        }
    }

    public func photoBrowser(_ photoBrowser: IDMPhotoBrowser, setupToolbar index: UInt, toolbar: UIToolbar) {
        if let cell = super.getCurrentCells()[Int(index)] as? ImageCellData {
            setupToolbar(toolbar: toolbar, cell: cell)
        }
    }
    
    public func photoBrowser(_ photoBrowser: IDMPhotoBrowser, didShowPhotoAt index: UInt) {
        if let cell = super.getCurrentCells()[Int(index)] as? ImageCellData {
            didShowPhoto(cell: cell)
        }
    }
}
