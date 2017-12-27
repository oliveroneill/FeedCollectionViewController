//
//  SingleImageView.swift
//  Pods
//
//  Created by Oliver ONeill on 1/01/2017.
//
//

import OOPhotoBrowser

/**
    To create your own custom caption view, subclass this view
    and override `setUpCaption()` and `sizeThatFits()` (as well as any other
    UIView methods that you see fit)

    This has the same parameters as `IDMCaptionView`
 */
open class SingleImageView: IDMCaptionView {
    public let cell:ImageCellData
    
    // serialising init, this won't be called
    required public init?(coder aDecoder: NSCoder) {
        self.cell = ImageCellData()
        super.init(coder: aDecoder)
    }

    public init(cell: ImageCellData) {
        self.cell = cell
        super.init(photo: cell)
    }

    /**
     * Setup your subviews and customise the appearance of your custom caption
     * You can access the image data by accessing the `cell` variable
     */
    open override func setupCaption() {
        super.setupCaption()
    }
    
    /**
     * Return a CGSize specifying the height of your custom caption view. The
     * width property is ignored and the caption is displayed
     * the full width of the screen
     */
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return super.sizeThatFits(size)
    }
}
