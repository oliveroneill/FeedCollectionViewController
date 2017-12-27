//
//  ErrorDataSource.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 23/12/17.
//

import UIKit

public protocol ErrorDataSource: class {
    /**
        Get the error message to be displayed when no content is available
        - Returns: An error message displayed using `ErrorPresenter`
     */
    func getErrorMessage() -> String
}
