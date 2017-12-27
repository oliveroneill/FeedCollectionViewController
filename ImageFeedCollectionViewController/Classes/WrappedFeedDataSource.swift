//
//  WrappedDataSource.swift
//  ImageFeedCollectionViewController
//
//  Created by Oliver ONeill on 24/12/17.
//

import UIKit
import FeedCollectionViewController

/**
    A wrapped class so that we can use custom `ImageCellData` delegates that
    communicate within `FeedCollectionView`s protocols.
*/
class WrappedFeedDataSource: FeedDataSource {
    private let imageDataSource: ImageFeedDataSource
    init(imageSource: ImageFeedDataSource) {
        imageDataSource = imageSource
    }

    func loadCell(cellView: UICollectionViewCell, cell: CellData) {
        if let imageCell = cell as? ImageCellData {
            imageDataSource.loadImageCell(cellView: cellView, cell: imageCell)
        }
    }

    func getCells(start: Int, callback: @escaping (([CellData]) -> Void)) {
        imageDataSource.getImageCells(start: start, callback: { cells in
            callback(cells)
        })
    }

    func getReuseIdentifier(cell:CellData) -> String {
        if let cell = cell as? ImageCellData {
            return imageDataSource.getImageReuseIdentifier(cell: cell)
        }
        // TODO: not sure if there's a good default here
        return ""
    }
}
