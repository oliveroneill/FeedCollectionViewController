//
//  WrappedImageFeedDelegate.swift
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
class WrappedFeedDelegate: FeedDelegate {
    private weak var presenter: PhotoBrowserPresenter?

    /**
        Create the wrapped delegate.

        - Parameter presenter: Used to display a single photoview
    */
    init(presenter: PhotoBrowserPresenter) {
        self.presenter = presenter
    }

    func didSelectCell(index: Int, cell: CellData) {
        presenter?.showPhotoBrowser(index: index)
    }
}
