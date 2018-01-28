//
//  ErrorMessageTests.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 11/02/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
import ImageFeedCollectionViewController
@testable import FeedCollectionViewController_Example

class ErrorMessageTests: FBSnapshotTestCase {
    private var c: ErroringColorFeedViewController!

    override func setUp() {
        super.setUp()
        // recordMode = true
        
        let storyboard = UIStoryboard(
            name: "Main",
            bundle: Bundle(for: ColorCaptionFeedViewController.self)
        )
        // Reset the default error message
        // TODO: doesn't feel good to have this static variable
        ErroringColorFeedViewController.errorMessage = "Something went wrong"
        let instantiated = storyboard.instantiateViewController(
            withIdentifier: "ErroringColorFeedViewController"
        ) as? ErroringColorFeedViewController
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
    }

    override func tearDown() {
        super.tearDown()
    }

    func verifyScreen() {
        guard let view = self.c.view else {
            XCTFail("Unexpected nil")
            return
        }
        self.FBSnapshotVerifyView(view)
        self.FBSnapshotVerifyLayer(view.layer)
    }

    func testErrorMessages() {
        testDisplay()
    }

    func testCustomErrorMessage() {
        ErroringColorFeedViewController.errorMessage = "Something went wrong. Please try again later."
        c.refreshFeed()
        testDisplay()
    }

    func testHidingMessage() {
        c.refreshFeed()
        let expect = expectation(description: "Wait for refresh to finish")
        // must wait for previous refresh to finish before reloading again
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // reload again with images
            self.c.length = 50
            self.c?.refreshFeed()
            // wait for images to load
            DispatchQueue.main.async {
                self.verifyScreen()
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

    func testDisplay() {
        let expect = expectation(description: "Wait for data to load")
        // wait for main thread to display current content
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.verifyScreen()
            expect.fulfill()
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
}
