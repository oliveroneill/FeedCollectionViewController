//
//  FeedDelegate.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 24/12/17.
//

import UIKit

public protocol FeedDelegate: class {
    /**
     * Called when a cell is tapped on. Consider implementing
     * `ImageLoadDelegate` if you plan on loading more images from a separate
     * view.
     * @param index - the index of the cell
     * @param cell - the data of the cell selected
     */
    func didSelectCell(index: Int, cell: CellData)
}
