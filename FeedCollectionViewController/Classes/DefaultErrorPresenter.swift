//
//  DefaultErrorPresenter.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 23/12/17.
//

import UIKit

class DefaultErrorPresenter: ErrorPresenter {
    private weak var parentView: UIView?
    private var errorText: UITextView?

    init(parentView: UIView) {
        self.parentView = parentView
    }

    func showErrorText(message:String) {
        hideErrorText()
        guard let parentView = parentView else {
            return
        }
        let errorDisplay = AdjustingErrorView(centerTextWithin: parentView)
        errorDisplay.text = message
        errorText = errorDisplay
        parentView.addSubview(errorDisplay)
    }

    func hideErrorText() {
        guard let text = errorText else {
            return
        }
        text.removeFromSuperview()
        errorText = nil
    }
}
