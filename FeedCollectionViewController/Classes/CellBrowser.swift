//
//  CellBrowser.swift
//  FeedViewController
//
//  Created by Oliver ONeill on 16/12/2016.
//  Copyright © 2016 Oliver ONeill. All rights reserved.
//

/**
 * `FeedCollectionViewController.loadMoreImages` takes an optional argument of
 * a CellBrowser. This allows the user to call `loadMoreImages` and be notified
 * via `imagesLoaded()` when these new images have been loaded. This is useful
 * when you are browsing through cells and want to load more and then update
 * your views.
 *
 * This would be used in a photo browser, when a user clicks on a cell it opens
 * up a fullsize photo and additional photos can be scrolled through, eventually
 * you'll need to call `FeedCollectionViewController.loadMoreImages` to retrieve
 * new images, this will then notify you to update your views when the new
 * images are set
 */
public protocol CellBrowser {
    /*
     * Implement this if you need to be notified of newly loaded images from
     * `FeedViewController.loadMoreImages()`
     */
    func imagesLoaded();
}
