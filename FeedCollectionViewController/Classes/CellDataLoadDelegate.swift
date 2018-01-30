//
//  CellDataLoadDelegate.swift
//  FeedViewController
//
//  Created by Oliver ONeill on 16/12/2016.
//

/**
    `FeedCollectionViewController.loadMoreCells` takes an optional argument of
    a CellDataLoadDelegate. This allows the user to call `loadMoreCells` and be
    notified via `cellDataLoaded()` when these new cells have been loaded. This
    is useful when you are browsing through cells and want to load more and then
    update your views.

    This would be used in a photo browser, when a user clicks on a cell it opens
    up a fullsize photo and additional photos can be scrolled through,
    eventually you'll need to call
    `FeedCollectionViewController.loadMoreCells` to retrieve new cells, this
    will then notify you to update your views when the new cells are set.
 */
public protocol CellDataLoadDelegate {
    /**
        Implement this to be notified when cells are newly loaded from
        `FeedCollectionViewController.loadMoreCells()`
     */
    func cellDataLoaded()
}
