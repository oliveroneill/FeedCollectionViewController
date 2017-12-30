//
//  ImageFeedDataSource.swift
//  ImageFeedCollectionViewController
//
//  Created by Oliver ONeill on 24/12/17.
//

import UIKit

public typealias ImageCellDataCallback = (([ImageCellData], Error?) -> Void)

/**
    A protocol based on `FeedCollectionViewController`'s `FeedDataSource` with
    functions specific to `ImageCellData`.
*/
public protocol ImageFeedDataSource: class {
    /**
     Get the reuse identifier for the cell, used to determine how to load
     the `UICollectionViewCell`. The cell data is specified if you wish to
     use different `UICollectionViewCell`s for different data

     - Parameter cell: The cell being loaded

     - Returns: Reuse identifier to be called with `dequeueReusableCell`
     */
    func getImageReuseIdentifier(cell: ImageCellData) -> String

    /**
     Load cells within the specified range and return them in a callback.
     This function is called multiple times to sequentially fill the
     CollectionView. The number of cells returned does not need to be large,
     however the amount is left up to the implementer.

     - Parameter start: The starting point of where data should be retrieved
     from in the list
     - Parameter callback: Return the corresponding cells through this
     callback
     */
    func getImageCells(start:Int, callback: @escaping ImageCellDataCallback)

    /**
     Called when a cell is being created from specified `ImageCellData`. Set up
     your `UICollectionViewCell` from the corresponding `ImageCellData` however
     you need to.

     - Parameter cellView: The view to modify
     - Parameter cell: - The data that should be used to modify the view
     */
    func loadImageCell(cellView: UICollectionViewCell, cell:ImageCellData)
}
