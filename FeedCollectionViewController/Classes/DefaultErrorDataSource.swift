//
//  DefaultErrorDataSource.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 24/12/17.
//

import UIKit

class DefaultErrorDataSource: ErrorDataSource {
    func getErrorMessage(error: Error?) -> String {
        return "No content"
    }
}
