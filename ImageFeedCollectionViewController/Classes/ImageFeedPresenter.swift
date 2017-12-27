//
//  ImageFeedPresenter.swift
//  ImageFeedCollectionViewController
//
//  Created by Oliver ONeill on 24/12/17.
//

import UIKit

/**
    Used to present the photo browser view, implement this for your own custom
    views. This has a default implementation of `SingleImageView`
*/
public protocol ImageFeedPresenter: class {
    func getSingleImageView(cell:ImageCellData) -> SingleImageView
}

public extension ImageFeedPresenter {
    func getSingleImageView(cell:ImageCellData) -> SingleImageView {
        return SingleImageView(cell: cell)
    }
}
