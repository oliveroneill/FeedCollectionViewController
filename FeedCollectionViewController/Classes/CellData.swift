//
//  CellData.swift
//  FeedViewController
//
//  Created by Oliver ONeill on 16/12/2016.
//  Copyright © 2016 Oliver ONeill. All rights reserved.
//

/**
 * The data corresponding to an individual cell in a
 * `FeedCollectionViewController`
 */
public protocol CellData {
    /**
     * This function is called when a new cell is visible. This should be used
     * to initialise the cells viewing components
     */
    func cellDidBecomeVisible();
}
