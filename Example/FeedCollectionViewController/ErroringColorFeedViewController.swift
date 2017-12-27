//
//  ErroringColorFeedViewController.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 11/02/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import FeedCollectionViewController
import ImageFeedCollectionViewController

// Default error message. Used in testing
var errorMessage: String = "Something went wrong"
class ErroringColorFeedViewController: ColorFeedViewController {
    private class CustomErrorDataSource: ErrorDataSource {
        func getErrorMessage() -> String {
            return errorMessage
        }
    }
    private let errorSource = CustomErrorDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        errorDataSource = errorSource
        ColorFeedViewController.length = -1
    }

    func refreshFeed() {
        refresh()
    }
}
