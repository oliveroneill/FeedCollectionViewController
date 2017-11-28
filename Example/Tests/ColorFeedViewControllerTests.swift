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
    private var c: ColorFeedViewController!
    
    override func setUp() {
        super.setUp()
        // uncomment this line to record snapshots for test
        // recordMode = true

        let storyboard = UIStoryboard(
            name: "Main",
            bundle: Bundle(for: ColorFeedViewController.self)
        )
        let instantiated = storyboard.instantiateViewController(
            withIdentifier: "ColorFeedViewController"
        ) as? ColorFeedViewController
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
        ColorFeedViewController.length = 50
        
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

    func scrollTo(index:Int, callback: @escaping (() -> Void)) {
        guard let collectionView = self.c.collectionView else {
            XCTFail("Unexpected nil")
            return
        }
        collectionView.scrollToItem(
            at: IndexPath(item:index, section: 0),
            at: .top,
            animated: true
        )
        // the scrolling animation takes time to run
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.c.scrollViewDidEndDecelerating(collectionView)
            callback()
        }
    }

    /**
     * Test that the initial screen matches
     */
    func testInitialScreen() {
        let expect = expectation(description: "Wait for data to load")
        // wait until the main thread is done displaying content
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

    /**
     * Test that the initial screen matches
     */
    func testRefresh() {
        let expect = expectation(description: "Wait for data to load")
        // wait until the main thread is done displaying content
        DispatchQueue.main.async {
            self.c.refreshContent()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
    
    /**
     * Test that scrolling down doesn't do anything strange
     */
    func testScroll() {
        let expect = expectation(description: "Wait for data to load")
        // wait until the main thread is done displaying content
        DispatchQueue.main.async {
            self.scrollTo(index: 9, callback: {
                self.verifyScreen()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.scrollTo(index: 19, callback: {
                self.scrollTo(index: 35, callback: {
                    self.verifyScreen()
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
            self.c.collectionView?.scrollToItem(
                at: IndexPath(item:19, section: 0),
                at: .top,
                animated: true
            )
            guard let collectionView = self.c.collectionView else {
                XCTFail("Unexpected nil")
                return
            }
            self.c.collectionView(
                collectionView,
                didSelectItemAt: IndexPath(item: 10, section: 0)
            )
            // wait for the selected item to appear
            DispatchQueue.main.async {
                if let view = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.view {
                    self.FBSnapshotVerifyView(view)
                    self.FBSnapshotVerifyLayer(view.layer)
                    expect.fulfill()
                } else {
                    XCTFail("Unexpected nil")
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
