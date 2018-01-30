//
//  CellData.swift
//  FeedViewController
//
//  Created by Oliver ONeill on 16/12/2016.
//

/**
    The data corresponding to an individual cell in a
    `FeedCollectionViewController`.
*/
public protocol CellData {
    /**
        This function is called when a new cell is visible. This should be used
        to initialise the cells view components
     */
    func cellDidBecomeVisible()
}
