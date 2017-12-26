//
//  WrappedImageFeedPresenter.swift
//  ImageFeedCollectionViewController
//
//  Created by Oliver ONeill on 24/12/17.
//

import UIKit
import FeedCollectionViewController

class WrappedFeedPresenter: FeedDelegate {
    private let feedPresenter: ImageFeedPresenter
    private weak var browserPresenter: PhotoBrowserPresenter?
    init(presenter: ImageFeedPresenter, browserPresenter: PhotoBrowserPresenter) {
        feedPresenter = presenter
        self.browserPresenter = browserPresenter
    }

    func didSelectCell(index: Int, cell: CellData) {
        browserPresenter?.showPhotoBrowser(index: index)
    }
}
