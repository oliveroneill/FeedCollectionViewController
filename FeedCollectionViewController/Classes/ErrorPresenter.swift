//
//  ErrorPresenter.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 23/12/17.
//

import UIKit

public protocol ErrorPresenter: class {
    /**
     * Use to display anything you need when no content is available.
     */
    func showErrorText(message:String)
    func hideErrorText()
}
