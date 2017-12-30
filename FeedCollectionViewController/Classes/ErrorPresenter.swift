//
//  ErrorPresenter.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 23/12/17.
//

import UIKit

/**
    A protocol called when no content is available. Note that this is not only
    in error cases but also when no content is available.
 */
public protocol ErrorPresenter: class {
    /**
        Use this to display any custom view when no content is available.
        - Parameter view: The view to modify
        - Parameter message: This message is retrieved from `ErrorDataSource`
     */
    func showErrorText(in view: UIView, message:String)
    func hideErrorText(in view: UIView)
}
