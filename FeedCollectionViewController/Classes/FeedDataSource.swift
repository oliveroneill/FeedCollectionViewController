//
//  FeedDataSource.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 23/12/17.
//

import UIKit

private let DEFAULT_CELLS_PER_ROW = 2

public protocol FeedDataSource: class {
    /**
        Get the reuse identifier for the cell, used to determine how to load
        the `UICollectionViewCell`. The cell data is specified if you wish to
        use different `UICollectionViewCell`s for different data

        - Parameter cell: The cell being loaded

        - Returns: Reuse identifier to be called with `dequeueReusableCell`
     */
    func getReuseIdentifier(cell: CellData) -> String

    /**
        Get the number of cells within the feed.

        - Returns: The number of cells in each row. This is defaulted at 2
     */
    func getCellsPerRow() -> Int

    /**
        Called when a cell is being created from specified `CellData`. Set up
        your `UICollectionViewCell` from the corresponding `CellData` however
        you need to.

        - Parameter cellView: The view to modify
        - Parameter cell: - The data that should be used to modify the view
     */
    func loadCell(cellView: UICollectionViewCell, cell:CellData)

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
    func getCells(start: Int, callback: @escaping (([CellData]) -> Void))
}

public extension FeedDataSource {
    func getCellsPerRow() -> Int {
        return DEFAULT_CELLS_PER_ROW
    }
}
