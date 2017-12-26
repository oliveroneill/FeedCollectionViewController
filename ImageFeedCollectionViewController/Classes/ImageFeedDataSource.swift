//
//  ImageFeedDataSource.swift
//  ImageFeedCollectionViewController
//
//  Created by Oliver ONeill on 24/12/17.
//

import UIKit

public protocol ImageFeedDataSource: class {
    func getImageReuseIdentifier(cell: ImageCellData) -> String
    func getImageCells(start:Int, callback: @escaping (([ImageCellData]) -> Void))
    func loadImageCell(cellView: UICollectionViewCell, cell:ImageCellData)
}
