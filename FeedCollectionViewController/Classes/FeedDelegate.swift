//
//  FeedDelegate.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 24/12/17.
//

import UIKit

public protocol FeedDelegate: class {
    /**
        Called when a cell is tapped on. Consider implementing
        `CellDataLoadDelegate` if you plan on loading more cells from a
        separate view.
        - Parameter index: The index of the cell
        - Parameter cell: The data of the cell selected
     */
    func didSelectCell(index: Int, cell: CellData)
}
