//
//  IDMCellBrowser.swift
//  Pods
//
//  Created by Oliver ONeill on 22/12/2016.
//
//

import FeedCollectionViewController
import OOPhotoBrowser

class IDMCellBrowser: CellBrowser {
    private var browser: IDMBrowserDelegate

    init(browser: IDMBrowserDelegate) {
        self.browser = browser
    }

    public func imagesLoaded() {
        browser.imagesLoaded()
    }

}
