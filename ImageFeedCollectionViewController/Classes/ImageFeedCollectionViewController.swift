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
    Subclass this for an infinite scrolling image feed with image browser built
    in. You should set `imageFeedSource` here as opposed to `feedDataSource`
    from `FeedCollectionViewController`.

    NOTE: do not set `feedDelegate` within this class, it is used to display
    the photo browser. You can access selection events via `browserDelegate`.
 */
open class ImageFeedCollectionViewController: FeedCollectionViewController {
    // Keep strong references here that will be given to
    // `FeedCollectionViewController`
    private var wrappedDataSource: WrappedFeedDataSource?
    private var wrappedDelegate: WrappedFeedDelegate?
    /// Required to specify a data source
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
    /// Use this to specify a custom image view for the image browser
    open weak var imageFeedPresenter: ImageFeedPresenter?
    /// Use this to receive events regarding the photo browser
    open weak var browserDelegate: PhotoBrowserDelegate?

    private var browser:IDMPhotoBrowser?

    open override func viewDidLoad() {
        super.viewDidLoad()
        wrappedDelegate = WrappedFeedDelegate(presenter: self)
        // TODO: wrapping this delegate means that users of the library
        // cannot use it themselves
        feedDelegate = wrappedDelegate
    }

    // Add new views to the photo browser that will hide on tap
    open func addToolbarView(view: UIView) {
        browser?.addToolbarView(view)
    }
}
extension ImageFeedCollectionViewController: PhotoBrowserPresenter {
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
extension ImageFeedCollectionViewController: IDMPhotoDataSource {
    public func photo(at index: UInt) -> IDMPhotoProtocol? {
        return cells[Int(index)] as? ImageCellData
    }

    public func numberOfPhotos() -> Int32 {
        return Int32(cells.count)
    }
    
    public func loadMoreImages(_ browser: IDMBrowserDelegate?) {
        var cellBrowser:IDMCellBrowser? = nil
        if let b = browser {
            cellBrowser = IDMCellBrowser(browser: b)
        }
        super.loadMoreCells(loadDelegate: cellBrowser)
    }
}

// MARK: IDMPhotoBrowserDelegate methods
extension ImageFeedCollectionViewController: IDMPhotoBrowserDelegate {
    public func photoBrowser(_ photoBrowser: IDMPhotoBrowser, captionViewForPhotoAt index: UInt) -> IDMCaptionView? {
        if let cell = cells[safe: Int(index)] as? ImageCellData {
            if cell.caption != nil {
                return imageFeedPresenter?.getSingleImageView(cell: cell)
            }
        }
        return nil
    }

    public func photoBrowser(_ photoBrowser: IDMPhotoBrowser, imageFailed index: UInt, imageView: IDMTapDetectingImageView) {
        if let cell = cells[safe: Int(index)] as? ImageCellData {
            browserDelegate?.imageDidFail(cell: cell, imageView:imageView)
        }
    }

    public func photoBrowser(_ photoBrowser: IDMPhotoBrowser, setupToolbar index: UInt, toolbar: UIToolbar) {
        if let cell = cells[safe: Int(index)] as? ImageCellData {
            browserDelegate?.setupToolbar(toolbar: toolbar, cell: cell)
        }
    }

    public func photoBrowser(_ photoBrowser: IDMPhotoBrowser, didShowPhotoAt index: UInt) {
        if let cell = cells[safe: Int(index)] as? ImageCellData {
            browserDelegate?.didShowPhoto(cell: cell)
        }
    }
}
