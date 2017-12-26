//
//  ImageFeedCollectionViewController.swift
//  Pods
//
//  Created by Oliver ONeill on 17/12/2016.
//
//

import FeedCollectionViewController
import OOPhotoBrowser

private extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

/**
 * Subclass this for an infinite scrolling image feed with image browser built
 * in. You must implement the corresponding image methods as opposed to
 * `FeedCollectionViewController`s methods.
 *
 * To use this class you must override: `getImageReuseIdentifier`,
 * `getImageCells` and `loadImageCell`
 */
open class ImageFeedCollectionViewController: FeedCollectionViewController, PhotoBrowserPresenter, IDMPhotoDataSource, IDMPhotoBrowserDelegate {
    private var wrappedDataSource: WrappedFeedDataSource?
    private var wrappedPresenter: WrappedFeedPresenter?
    open weak var imageFeedSource: ImageFeedDataSource? {
        didSet {
            // When this is created we wrap the underlying data source in it.
            // This allows us to use delegate methods that point to the
            // `ImageCellData` type
            if let source = imageFeedSource {
                wrappedDataSource = WrappedFeedDataSource(imageSource: source)
                feedDataSource = wrappedDataSource
            } else {
                // deallocate these when set to nil
                wrappedDataSource = nil
                feedDataSource = nil
            }
        }
    }
    open weak var imageFeedPresenter: ImageFeedPresenter? {
        didSet {
            // When this is created we wrap the underlying data source in it.
            // This allows us to use delegate methods that point to the
            // `ImageCellData` type
            if let presenter = imageFeedPresenter {
                wrappedPresenter = WrappedFeedPresenter(
                    presenter: presenter,
                    browserPresenter: self
                )
                feedDelegate = wrappedPresenter
            } else {
                // deallocate these when set to nil
                wrappedPresenter = nil
                feedDelegate = nil
            }
        }
    }
    open weak var browserDelegate: PhotoBrowserDelegate?

    private var browser:IDMPhotoBrowser?

    // Add new views to the photo browser that will hide on tap
    open func addToolbarView(view: UIView) {
        browser?.addToolbarView(view)
    }

    func showPhotoBrowser(index: Int) {
        guard let browser = IDMPhotoBrowser(dataSource: self) else {
            return
        }
        browser.setInitialPageIndex(UInt(index))
        browser.delegate = self
        self.browser = browser
        self.present(browser, animated: true, completion: {})
    }
}

// MARK: IDMPhotoDataSource methods
extension ImageFeedCollectionViewController {
    public func photo(at index: UInt) -> IDMPhotoProtocol? {
        let cells = getCurrentCells()
        return cells[Int(index)] as? ImageCellData
    }

    public func numberOfPhotos() -> Int32 {
        return Int32(getCurrentCells().count)
    }
    
    public func loadMoreImages(_ browser: IDMBrowserDelegate?) {
        var cellBrowser:IDMCellBrowser? = nil
        if let b = browser {
            cellBrowser = IDMCellBrowser(browser: b)
        }
        super.loadMoreImages(browser: cellBrowser)
    }
}

// MARK: IDMPhotoBrowserDelegate methods
extension ImageFeedCollectionViewController {
    public func photoBrowser(_ photoBrowser: IDMPhotoBrowser, captionViewForPhotoAt index: UInt) -> IDMCaptionView? {
        if let cell = getCurrentCells()[safe: Int(index)] as? ImageCellData {
            if cell.caption != nil {
                return imageFeedPresenter?.getSingleImageView(cell: cell)
            }
        }
        return nil
    }

    public func photoBrowser(_ photoBrowser: IDMPhotoBrowser, imageFailed index: UInt, imageView: IDMTapDetectingImageView) {
        if let cell = getCurrentCells()[safe: Int(index)] as? ImageCellData {
            browserDelegate?.imageDidFail(cell: cell, imageView:imageView)
        }
    }

    public func photoBrowser(_ photoBrowser: IDMPhotoBrowser, setupToolbar index: UInt, toolbar: UIToolbar) {
        if let cell = getCurrentCells()[safe: Int(index)] as? ImageCellData {
            browserDelegate?.setupToolbar(toolbar: toolbar, cell: cell)
        }
    }

    public func photoBrowser(_ photoBrowser: IDMPhotoBrowser, didShowPhotoAt index: UInt) {
        if let cell = getCurrentCells()[safe: Int(index)] as? ImageCellData {
            browserDelegate?.didShowPhoto(cell: cell)
        }
    }
}
