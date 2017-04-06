//
//  FeedCollectionViewController.swift
//  FeedViewController
//
//  Created by Oliver ONeill on 16/12/2016.
//  Copyright © 2016 Oliver ONeill. All rights reserved.
//

import UIKit

/**
 * Subclass this for a simple interface for an infinite scrolling feed using
 * the standard `UICollectionViewController` setup
 *
 * To use this class you must override: `getReuseIdentifier`, `getCells` and
 * `loadCell`
 */
open class FeedCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private var cellData:[CellData] = []
    private let refreshControl = UIRefreshControl()
    private var start = -1
    private var end = -1

    private var cellsPerRow = 2

    private var errorText:UITextView?

    // MARK: abstract functions

    /**
     * Return the reuse identifier for the cell, used to determine how to load
     * the `UICollectionViewCell`. The cell data is specified if you wish to
     * use different `UICollectionViewCell`s for different data
     *
     * @param cell - the cell being loaded
     */
    open func getReuseIdentifier(cell:CellData) -> String {
        preconditionFailure("getReuseIdentifier must be overridden")
    }

    /**
     * Load cells within the specified range and return them in a callback.
     * This function is called multiple times to sequentially fill the
     * CollectionView. The number of cells returned does not need to be large,
     * however the amount is left up to the implementer
     *
     * NOTE: `callback` uses the main thread, so `callback` must be called from
     * a different thread. It's assumed that `getCells` is an asynchronous call.
     *
     * @param start - the starting point of where data should be retrieved from
     * in the list
     * @param callback - return the corresponding cells through this callback
     */
    open func getCells(start:Int, callback: @escaping (([CellData]) -> Void)) {
        preconditionFailure("getCells must be overridden")
    }

    /**
     * Called when a cell is being created from specified `CellData`. Set up
     * your `UICollectionViewCell` from the corresponding `CellData` however you
     * need to.
     * @param cellView - the view to modify
     * @param cell - the data that should be used to modify the view
     */
    open func loadCell(cellView: UICollectionViewCell, cell:CellData) {
        preconditionFailure("loadCell must be overridden")
    }
    
    // MARK: useful functions
    
    /**
     * Called when a cell is tapped on. Consider implementing `CellBrowser` if
     * you plan on loading more images from a separate view
     * @param index - the index of the cell
     * @param cell - the data of the cell selected
     */
    open func didSelectCell(index:Int, cell:CellData) {
    }

    /**
     * Returns the number of cells in each row. This is defaulted at 2
     */
    open func getCellsPerRow() -> Int {
        return cellsPerRow
    }
    
    /**
     * Return an error message to be displayed when no content is available
     */
    open func getErrorMessage() -> String {
        return "No content"
    }
    
    /**
     * Use to display anything you need when no content is available.
     * Alternatively just override `getErrorMessage` for a simple way of
     * displaying a message
     */
    open func showErrorText() {
        guard let c = self.collectionView else {
            return
        }
        let textHeight:CGFloat = 50
        errorText = UITextView(
            frame: CGRect(
                x: 0,
                y: c.frame.height/2 - textHeight/2,
                width: c.frame.width,
                height: textHeight
            )
        )
        errorText!.text = self.getErrorMessage()
        errorText!.font = UIFont(name: "Helvetica", size: 32)
        errorText!.textAlignment = .center
        errorText!.textColor = .gray
        errorText!.isSelectable = false
        errorText!.isEditable = false
        errorText!.isScrollEnabled = false
        // resize to fit text
        errorText!.sizeToFit()
        errorText!.frame = CGRect(x: 0, y: c.frame.height/2 - errorText!.frame.height/2, width: c.frame.width, height: errorText!.frame.height)
        c.addSubview(errorText!)
    }
    
    /**
     * Override this when implementing `showErrorText`
     */
    open func hideErrorText() {
        guard let text = errorText else {
            return
        }
        text.removeFromSuperview()
        errorText = nil
    }
    
    /**
     * Call this to load new images. Optionally specify a `CellBrowser` if you
     * wish to be notified via `CellBrowser.imagesLoaded()` when new images have
     * have been created
     *
     * @param browser - optionally specified to notify additional views of newly
     * loaded images
     */
    public final func loadMoreImages(browser:CellBrowser?) {
        getCells(start: self.cellData.count, callback: { data in
            // if there's nothing to add then don't do anything
            if data.count == 0 {
                return
            }
            // keep track of last cell so that we only load new data
            let size = self.cellData.count
            self.cellData.append(contentsOf: data)
            // create indexes to load
            var indexes: [IndexPath] = []
            for i in size..<self.cellData.count {
                indexes.append(IndexPath(row: i, section: 0))
            }
            DispatchQueue.main.sync {
                self.collectionView?.insertItems(at: indexes)
                self.collectionView?.reloadItems(at: indexes)
                browser?.imagesLoaded()
            }
            // there won't be any visible images until the
            // data has been reloaded, so we wait here
            // TODO: figure out how to know when data is
            // populated
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
                // reset counters here so that data is completely refreshed
                self.start = -1
                self.end = -1
                self.showVisibleImages()
            })
            
        })
    }
    
    public final func getCurrentCells() -> [CellData] {
        return cellData
    }
    
    // MARK: internal functions
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // add UIRefreshControl for scroll down to refresh
        refreshControl.addTarget(self, action: #selector(FeedCollectionViewController.refresh), for: .valueChanged)
        self.collectionView!.addSubview(refreshControl)
        
        self.collectionView?.alwaysBounceVertical = true
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        // scroll down, so that the spinning wheel can be seen on first refresh
        self.collectionView?.setContentOffset(
            CGPoint(x: 0, y: -self.refreshControl.frame.size.height),
            animated: true
        )
        refresh()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public final func refresh() {
        hideErrorText()
        refreshControl.beginRefreshing()
        // scroll to reveal spinning wheel
        self.collectionView?.setContentOffset(
            CGPoint(x: 0, y: -self.refreshControl.frame.size.height),
            animated: true
        )
        getCells(start: 0, callback: { cellData in
            self.cellData = cellData
            DispatchQueue.main.sync {
                self.collectionView?.reloadData()
                self.refreshControl.endRefreshing()
                // scroll to hide refresh control
                self.collectionView?.setContentOffset(
                    CGPoint(x: 0, y: 0),
                    animated: true
                )
                if cellData.count == 0 {
                    self.showErrorText()
                }
            }
            // there won't be any visible images until the
            // data has been reloaded, so we wait here
            // TODO: figure out how to know when data is
            // populated
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
                // reset counters here so that data is completely refreshed
                self.start = -1
                self.end = -1
                self.showVisibleImages()
            })
        })
    }

    private final func showVisibleImages() {
        self.collectionView?.layoutIfNeeded()
        guard let visibles = self.collectionView?.indexPathsForVisibleItems else {
            return
        }
        guard let startPath = visibles.first, let endPath = visibles.last else {
            return
        }
        if (startPath.row == start) && (endPath.row == end) && (endPath.row < self.cellData.count - 4) {
            return
        }
        start = startPath.row
        end = endPath.row
        for indexPath in visibles {
            self.newCellVisible(at: indexPath.row)
        }
    }
    
    private final func newCellVisible(at:Int) {
        if at < self.cellData.count {
            // set cell with image
            DispatchQueue.global(qos: .background).async {
                self.cellData[at].cellDidBecomeVisible()
            }
        }
    }
    
    // MARK: UICollectionViewDataSource

    override open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCell(index: indexPath.row, cell: cellData[indexPath.row])
    }
    
    override open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellData.count
    }
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // add safe default in case cells are deleted
        var row = indexPath.row
        if row > self.cellData.count {
            row = self.cellData.count - 1
        }
        let c = self.cellData[row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getReuseIdentifier(cell: c), for: indexPath)
        loadCell(cellView: cell, cell: c)
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let cellWidth = screenWidth / CGFloat(getCellsPerRow())
        let size = CGSize(width: cellWidth, height: cellWidth)
        return size;
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    //MARK: scrollView methods
    override open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        showVisibleImages()
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        // load more images when the user has scrolled 70% of the current feed
        if bottomEdge >= scrollView.contentSize.height * 0.7 {
            loadMoreImages(browser: nil)
        }
    }
    
    override open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            showVisibleImages()
        }
    }
}
