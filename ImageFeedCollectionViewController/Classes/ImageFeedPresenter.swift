//
//  ImageFeedPresenter.swift
//  ImageFeedCollectionViewController
//
//  Created by Oliver ONeill on 24/12/17.
//

import UIKit

public protocol ImageFeedPresenter: class {
    func getSingleImageView(cell:ImageCellData) -> SingleImageView
}

public extension ImageFeedPresenter {
    func getSingleImageView(cell:ImageCellData) -> SingleImageView {
        return SingleImageView(cell: cell)
    }
}
