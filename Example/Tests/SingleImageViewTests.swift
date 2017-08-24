//
//  SingleImageViewTests.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 2/01/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
import ImageFeedCollectionViewController
@testable import FeedCollectionViewController_Example

/**
 * Test example feed with caption customisation
 */
class SingleImageViewTests: FBSnapshotTestCase {
    private var c: ColorFeedViewController?

    override func setUp() {
        super.setUp()
         // recordMode = true
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: ColorCaptionFeedViewController.self))
        c = storyboard.instantiateViewController(withIdentifier: "ColorCaptionFeedViewController") as? ColorCaptionFeedViewController
        // we don't require a delay for the unit tests
        c?.loadingDelay = 0
        c?.imageDelay = 0
        UIApplication.shared.keyWindow!.rootViewController = c
        ColorFeedViewController.LENGTH = 50
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCaption() {
        let expect = expectation(description: "Wait for data to load")
        // wait for view controller to initialise
        DispatchQueue.main.async {
            self.c!.collectionView?.scrollToItem(at: IndexPath(item:19, section: 0), at: .top, animated: true)
            self.c?.collectionView((self.c?.collectionView)!, didSelectItemAt: IndexPath(item: 10, section: 0))
            // wait for selected item to appear
            DispatchQueue.main.async {
                if let topController = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController {
                    self.FBSnapshotVerifyView(topController.view!)
                    self.FBSnapshotVerifyLayer(topController.view!.layer)
                    expect.fulfill()
                }
            }
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
}
