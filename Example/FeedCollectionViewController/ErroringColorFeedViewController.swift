//
//  ErroringColorFeedViewController.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 11/02/2017.
//

import UIKit
import FeedCollectionViewController
import ImageFeedCollectionViewController

class ErroringColorFeedViewController: ColorFeedViewController {
    // Default error message. Used in testing
    static var errorMessage = "Something went wrong"

    private class CustomErrorDataSource: ErrorDataSource {
        func getErrorMessage(error: Error?) -> String {
            return errorMessage
        }
    }
    private let errorSource = CustomErrorDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        errorDataSource = errorSource
        // in the error case we have no data
        length = -1
    }

    func refreshFeed() {
        refresh()
    }
}
