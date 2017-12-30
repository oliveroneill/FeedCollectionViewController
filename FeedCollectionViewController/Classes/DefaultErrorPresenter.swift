//
//  DefaultErrorPresenter.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 23/12/17.
//

import UIKit

class DefaultErrorPresenter: ErrorPresenter {
    private var errorText: UITextView?

    func showErrorText(in view: UIView, message:String) {
        hideErrorText(in: view)
        let errorDisplay = AdjustingErrorView(centerTextWithin: view)
        errorDisplay.text = message
        errorText = errorDisplay
        view.addSubview(errorDisplay)
    }

    func hideErrorText(in view: UIView) {
        guard let text = errorText else {
            return
        }
        text.removeFromSuperview()
        errorText = nil
    }
}
