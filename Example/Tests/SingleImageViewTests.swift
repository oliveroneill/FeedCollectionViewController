//
//  SingleImageViewTests.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 2/01/2017.
//

import XCTest
import FBSnapshotTestCase
import ImageFeedCollectionViewController
@testable import FeedCollectionViewController_Example

/**
 * Test example feed with caption customisation
 */
class SingleImageViewTests: FBSnapshotTestCase {
    private var c: ColorFeedViewController!

    override func setUp() {
        super.setUp()
         // recordMode = true
        
        let storyboard = UIStoryboard(
            name: "Main",
            bundle: Bundle(for: ColorCaptionFeedViewController.self)
        )
        let instantiated = storyboard.instantiateViewController(
            withIdentifier: "ColorCaptionFeedViewController"
        ) as? ColorCaptionFeedViewController
        guard let controller = instantiated else {
            XCTFail("Unexpected nil storyboard instantiation")
            return
        }
        self.c = controller
        // we don't require a delay for the unit tests
        c.loadingDelay = 0
        c.imageDelay = 0
        guard let window = UIApplication.shared.keyWindow else {
            XCTFail("Unexpected nil window")
            return
        }
        window.rootViewController = c
        c.length = 50
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testCaption() {
        let expect = expectation(description: "Wait for data to load")
        // wait for view controller to initialise
        DispatchQueue.main.async {
            guard let collectionView = self.c.collectionView else {
                XCTFail("Unexpected nil")
                return
            }
            collectionView.scrollToItem(
                at: IndexPath(item:19, section: 0),
                at: .top,
                animated: true
            )
            self.c.collectionView(
                collectionView,
                didSelectItemAt: IndexPath(item: 10, section: 0)
            )
            // wait for selected item to appear
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let view = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.view {
                    self.FBSnapshotVerifyView(view)
                    self.FBSnapshotVerifyLayer(view.layer)
                    expect.fulfill()
                } else {
                    XCTFail("Unexpected nil view")
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
