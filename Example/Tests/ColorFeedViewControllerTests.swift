import UIKit
import XCTest
import FBSnapshotTestCase
@testable import FeedCollectionViewController_Example

// UIViewController+Extension
extension UIViewController {
    // used to initialise view controller for each test
    func preloadView() {
        _ = view
    }
}

class ColorFeedViewControllerTests: FBSnapshotTestCase {
    private var c: ColorFeedViewController?
    
    override func setUp() {
        super.setUp()
        // uncomment this line to record snapshots for test
        // recordMode = true

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: ColorFeedViewController.self))
        c = storyboard.instantiateViewController(withIdentifier: "ColorFeedViewController") as? ColorFeedViewController
        // we don't require a delay for the unit tests
        c?.loadingDelay = 0
        c?.imageDelay = 0
        UIApplication.shared.keyWindow!.rootViewController = c
        ColorFeedViewController.LENGTH = 50
        
    }

    override func tearDown() {
        super.tearDown()
    }

    func scrollTo(index:Int, callback: @escaping (() -> Void)) {
        self.c!.collectionView!.scrollToItem(at: IndexPath(item:index, section: 0), at: .top, animated: true)
        // the scrolling animation takes time to run
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.c!.scrollViewDidEndDecelerating(self.c!.collectionView!)
            callback()
        }
    }

    /**
     * Test that the initial screen matches
     */
    func testInitialScreen() {
        let expect = expectation(description: "Wait for data to load")
        // wait until the main thread is done displaying content
        DispatchQueue.main.async {
            let view = self.c!.view
            self.FBSnapshotVerifyView(view!)
            self.FBSnapshotVerifyLayer(view!.layer)
            expect.fulfill()
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

    /**
     * Test that the initial screen matches
     */
    func testRefresh() {
        let expect = expectation(description: "Wait for data to load")
        // wait until the main thread is done displaying content
        DispatchQueue.main.async {
            self.c!.refreshContent()
            DispatchQueue.main.async {
                let view = self.c!.view
                self.FBSnapshotVerifyView(view!)
                self.FBSnapshotVerifyLayer(view!.layer)
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    /**
     * Test that scrolling down doesn't do anything strange
     */
    func testScroll() {
        let expect = expectation(description: "Wait for data to load")
        // wait until the main thread is done displaying content
        DispatchQueue.main.async {
            self.scrollTo(index: 9, callback: {
                let view = self.c!.view
                self.FBSnapshotVerifyView(view!)
                self.FBSnapshotVerifyLayer(view!.layer)
                expect.fulfill()
            })
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    /**
     * Test that scrolling down loads new images
     */
    func testScrollToNewScreen() {
        let expect = expectation(description: "Wait for data to load")
        // wait until the main thread is done displaying content
        DispatchQueue.main.async {
            self.scrollTo(index: 19, callback: {
                self.scrollTo(index: 35, callback: {
                    let view = self.c!.view
                    self.FBSnapshotVerifyView(view!)
                    self.FBSnapshotVerifyLayer(view!.layer)
                    expect.fulfill()
                })
            })
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    /**
     * Test that tapping on a cell opens the photo browser
     */
    func testTapOnCell() {
        let expect = expectation(description: "Wait for data to load")
        // wait until the main thread is done displaying content
        DispatchQueue.main.async {
            self.c!.collectionView?.scrollToItem(at: IndexPath(item:19, section: 0), at: .top, animated: true)
            self.c?.collectionView((self.c?.collectionView)!, didSelectItemAt: IndexPath(item: 10, section: 0))
            // wait for the selected item to appear
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
