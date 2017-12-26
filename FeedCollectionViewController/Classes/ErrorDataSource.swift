//
//  ErrorDataSource.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 23/12/17.
//

import UIKit

public protocol ErrorDataSource: class {
    /**
     * Return an error message to be displayed when no content is available
     */
    func getErrorMessage() -> String
}
