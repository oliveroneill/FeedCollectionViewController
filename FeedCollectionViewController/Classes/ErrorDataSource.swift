//
//  ErrorDataSource.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 23/12/17.
//

import UIKit

/**
    A protocol called when no content is available. Note that this is not only
    in error cases but also when no content is available.
 */
public protocol ErrorDataSource: class {
    /**
        Get the error message to be displayed when no content is available
        - Parameter error: Relevant error info. This may be nil if this is not
        an error case but there is still no content available.

        - Returns: An error message displayed using `ErrorPresenter`
     */
    func getErrorMessage(error: Error?) -> String
}
