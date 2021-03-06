//
//  FeedCollectionViewController.swift
//  FeedViewController
//
//  Created by Oliver ONeill on 16/12/2016.
//

import UIKit

private extension DispatchQueue {
    // Use this method to avoid EXC_BAD_INSTRUCTION while currently on the main
    // thread
    class func mainSyncSafe(execute work: () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.sync(execute: work)
        }
    }
}

/**
    Subclass this for a simple interface for an infinite scrolling feed using
    the standard `UICollectionViewController` setup.

    To use this class you must set the `feedDataSource` variable. You can also
    optionally override `errorDataSource`, `feedDelegate` and `errorDelegate`
    for additional functionality.
 */
open class FeedCollectionViewController: UICollectionViewController {
    private var defaultErrorSource = DefaultErrorDataSource()
    private var defaultErrorPresenter: ErrorPresenter?

    /// Required to specify a data source
    open weak var feedDataSource: FeedDataSource?
    /// Set this for customised error messages
    open weak var errorDataSource: ErrorDataSource?
    /// Additional delegates
    open weak var feedDelegate: FeedDelegate?
    /// Use for customised actions on error cases
    open weak var errorPresenter: ErrorPresenter?

    public private(set) var cells: [CellData] = []
    private let refreshControl = UIRefreshControl()
    private var start: Int?
    private var end: Int?

    /**
        Call this to load new cells. Optionally specify a `CellDataLoadDelegate`
        if you wish to be notified via `CellDataLoadDelegate.cellDataLoaded()`
        when new cells have been created.

        - Parameter loadDelegate: Optionally specified to notify additional
        views of newly loaded cells
     */
    public final func loadMoreCells(loadDelegate: CellDataLoadDelegate?) {
        feedDataSource?.getCells(start: cells.count, callback: { [unowned self] data, _ in
            // if there's nothing to add then don't do anything
            if data.count == 0 {
                return
            }
            // keep track of last cell so that we only load new data
            let size = self.cells.count
            self.cells.append(contentsOf: data)
            // create indexes to load
            let indexes = Array(size..<self.cells.count).map {
                IndexPath(row: $0, section: 0)
            }
            DispatchQueue.mainSyncSafe {
                self.collectionView?.insertItems(at: indexes)
                self.collectionView?.reloadItems(at: indexes)
                loadDelegate?.cellDataLoaded()
                self.newCellsLoaded()
            }
        })
    }
}

// MARK: internal functions
extension FeedCollectionViewController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        setDelegateDefaults()
        // set feed layout
        initialiseCollectionViewLayout()
        // add UIRefreshControl for scroll down to refresh
        refreshControl.addTarget(
            self,
            action: #selector(FeedCollectionViewController.refresh),
            for: .valueChanged
        )
        collectionView?.addSubview(refreshControl)
        collectionView?.alwaysBounceVertical = true
    }

    override open func viewDidAppear(_ animated: Bool) {
        refresh()
    }

    private final func initialiseCollectionViewLayout() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.footerReferenceSize = .zero
            layout.headerReferenceSize = .zero
            layout.sectionInset = .zero
        }
    }

    private final func setDelegateDefaults() {
        // set a default if its not already set
        if errorPresenter == nil {
            // store in strong reference variable first
            defaultErrorPresenter = DefaultErrorPresenter()
            errorPresenter = defaultErrorPresenter
        }
        // safe default
        errorDataSource = errorDataSource ?? defaultErrorSource
    }

    @objc public final func refresh() {
        guard let collectionView = self.collectionView else {
            return
        }
        errorPresenter?.hideErrorText(in: collectionView)
        guard let dataSource = feedDataSource else {
            return
        }
        refreshControl.beginRefreshing()
        // scroll to reveal spinning wheel
        collectionView.setContentOffset(
            CGPoint(x: 0, y: -refreshControl.frame.size.height),
            animated: true
        )
        dataSource.getCells(start: 0, callback: { [unowned self] cellData, error in
            self.cells = cellData
            DispatchQueue.mainSyncSafe {
                collectionView.reloadData()
                self.refreshControl.endRefreshing()
                // scroll to hide refresh control
                collectionView.setContentOffset(.zero, animated: true)
                if cellData.count == 0 {
                    self.showError(collectionView: collectionView, error: error)
                }
                self.newCellsLoaded()
            }
        })
    }

    private final func showError(collectionView: UICollectionView, error: Error?) {
        self.errorPresenter?.showErrorText(
            in: collectionView,
            message: self.errorDataSource?.getErrorMessage(error: error) ?? ""
        )
    }

    private final func newCellsLoaded() {
        // reset counters here so that data is completely refreshed
        self.start = nil
        self.end = nil
        self.showVisibleCells()
    }

    private final func showVisibleCells() {
        collectionView?.layoutIfNeeded()
        guard let visibles = collectionView?.indexPathsForVisibleItems else {
            return
        }
        guard let startPath = visibles.first, let endPath = visibles.last else {
            return
        }
        // ignore if we've already updated these indices
        if startPath.row == start && endPath.row == end {
            return
        }
        start = startPath.row
        end = endPath.row
        for indexPath in visibles {
            newCellVisible(at: indexPath.row)
        }
    }

    private final func newCellVisible(at index: Int) {
        if index < cells.count {
            cells[index].cellDidBecomeVisible()
        }
    }
}

// MARK: UICollectionViewDataSource
extension FeedCollectionViewController {
    override open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        feedDelegate?.didSelectCell(
            index: indexPath.row,
            cell: cells[indexPath.row]
        )
    }

    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }

    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dataSource = feedDataSource else {
            return UICollectionViewCell()
        }
        // add safe default in case cells are deleted
        if indexPath.row > cells.count {
            return UICollectionViewCell()
        }
        let c = cells[indexPath.row]
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: dataSource.getReuseIdentifier(cell: c),
            for: indexPath
        )
        feedDataSource?.loadCell(cellView: cell, cell: c)
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension FeedCollectionViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let dataSource = feedDataSource else {
            return .zero
        }
        let width = collectionView.frame.size.width
        let cellWidth = width / CGFloat(dataSource.getCellsPerRow())
        return CGSize(width: cellWidth, height: cellWidth)
    }

    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionViewLayout.invalidateLayout()
    }
}

//MARK: UIScrollView methods
extension FeedCollectionViewController {
    override open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        showVisibleCells()
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        // load more cells when the user has scrolled 70% of the current feed
        if bottomEdge >= scrollView.contentSize.height * 0.7 {
            loadMoreCells(loadDelegate: nil)
        }
    }
    
    override open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            showVisibleCells()
        }
    }
}
