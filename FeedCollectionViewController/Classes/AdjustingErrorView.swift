//
//  AdjustingErrorView.swift
//  DACircularProgress
//
//  Created by Oliver ONeill on 20/12/17.
//

import UIKit

private let textHeight: CGFloat = 50

/**
 * A default view for displaying errors within the feed.
 * This will center the text within a specified container and handle multiple
 * line error messages as well as the formatting
 */
class AdjustingErrorView: UITextView {
    var containerToCenterText:UIView? {
        didSet {
            adjustSize()
        }
    }

    override var text: String! {
        didSet {
            adjustSize()
        }
    }

    /**
     * Create a text view that will center the text within the container view
     */
    convenience init(centerTextWithin container:UIView) {
        // set frame to center within view
        self.init(
            frame: CGRect(
                x: 0,
                y: container.frame.height/2 - textHeight/2,
                width: container.frame.width,
                height: textHeight
            ), textContainer: nil
        )
        self.containerToCenterText = container
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        // default formatting and style
        self.font = UIFont(name: "Helvetica", size: 32)
        self.textAlignment = .center
        self.textColor = .gray
        self.isSelectable = false
        self.isEditable = false
        self.isScrollEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Adjust size for new message or new containing view
    private func adjustSize() {
        guard let parent = self.containerToCenterText else {
            return
        }
        self.sizeToFit()
        self.frame = CGRect(
            x: 0,
            y: parent.frame.height/2 - self.frame.height/2,
            width: parent.frame.width,
            height: self.frame.height
        )
    }
}
