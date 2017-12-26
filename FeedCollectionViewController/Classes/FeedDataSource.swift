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
     * Return the reuse identifier for the cell, used to determine how to load
     * the `UICollectionViewCell`. The cell data is specified if you wish to
     * use different `UICollectionViewCell`s for different data
     *
     * @param cell - the cell being loaded
     */
    func getReuseIdentifier(cell: CellData) -> String

    /**
     * Returns the number of cells in each row. This is defaulted at 2
     */
    func getCellsPerRow() -> Int

    /**
     * Called when a cell is being created from specified `CellData`. Set up
     * your `UICollectionViewCell` from the corresponding `CellData` however you
     * need to.
     * @param cellView - the view to modify
     * @param cell - the data that should be used to modify the view
     */
    func loadCell(cellView: UICollectionViewCell, cell:CellData)

    /**
     * Load cells within the specified range and return them in a callback.
     * This function is called multiple times to sequentially fill the
     * CollectionView. The number of cells returned does not need to be large,
     * however the amount is left up to the implementer
     *
     * @param start - the starting point of where data should be retrieved from
     * in the list
     * @param callback - return the corresponding cells through this callback
     */
    func getCells(start: Int, callback: @escaping (([CellData]) -> Void))
}

public extension FeedDataSource {
    func getCellsPerRow() -> Int {
        return DEFAULT_CELLS_PER_ROW
    }
}
