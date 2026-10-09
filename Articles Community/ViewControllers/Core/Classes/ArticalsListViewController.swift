//
//  ArticalsListViewController.swift
//  Articles Community
//
//  Created by Veeru Masal on 08/10/26.
//

import UIKit

class ArticalsListViewController: UIViewController {

    // MARK: - Constants
    private enum Constants {
        static let listCellID = "ArticalsListTableViewCell"
        static let gridCellID = "ArticalsGridViewCollectionViewCell"
        static let estimatedRowHeight: CGFloat = 363
        static let gridColumns: CGFloat = 2
        static let gridSpacing: CGFloat = 10
        static let gridInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        static let toggleDuration: TimeInterval = 0.25
    }

    // MARK: - Outlets
    @IBOutlet weak var articlesListView: UITableView!
    @IBOutlet weak var articlesGridView: UICollectionView!
    @IBOutlet weak var headerView: ArticlesHeaderContainer!

    // MARK: - Properties
    private let manager = ArticlesManager()
    private var articles: [Article] = []
    private var isGridMode = false          // false = list is the default on first load
    private var isFetching = false
    private var isShowingOffline = false
   

    private var activeView: UIView { isGridMode ? articlesGridView : articlesListView }
    private var inactiveView: UIView { isGridMode ? articlesListView : articlesGridView }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupListView()
        setupGridView()
        setupHeader()
        setupRefreshControls()
        applyLayoutMode(animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if articles.isEmpty { fetchArticles() }
    }

    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.articlesGridView.collectionViewLayout.invalidateLayout()
        })
    }

    // MARK: - Setup
    private func setupListView() {
        articlesListView.delegate = self
        articlesListView.dataSource = self
        articlesListView.register(UINib(nibName: Constants.listCellID, bundle: nil),
                                  forCellReuseIdentifier: Constants.listCellID)
        articlesListView.rowHeight = UITableView.automaticDimension
        articlesListView.estimatedRowHeight = Constants.estimatedRowHeight
        articlesListView.alwaysBounceVertical = true     // lets the user pull even with few rows
    }

    private func setupGridView() {
        articlesGridView.delegate = self
        articlesGridView.dataSource = self
        articlesGridView.register(UINib(nibName: Constants.gridCellID, bundle: nil),
                                  forCellWithReuseIdentifier: Constants.gridCellID)
        articlesGridView.alwaysBounceVertical = true
    }

    private func setupHeader() {
        headerView.attach(to: self)
        headerView.onGridTap = { [weak self] in self?.toggleLayout() }
        headerView.onSearchTap = { [weak self] in self?.openSearch() }
    }

    private func setupRefreshControls() {
        articlesListView.refreshControl = makeRefreshControl()
        articlesGridView.refreshControl = makeRefreshControl()
    }

    private func makeRefreshControl() -> UIRefreshControl {
        let control = UIRefreshControl()
        control.addAction(UIAction { [weak self] _ in
            self?.refreshArticles()
        }, for: .valueChanged)
        return control
    }

    // MARK: - Layout toggle
    private func toggleLayout() {
        isGridMode.toggle()
        applyLayoutMode(animated: true)
    }

    private func applyLayoutMode(animated: Bool) {
        reloadVisibleContent()
        headerView.updateToggleIcon(isGridMode: isGridMode)

        let show = activeView
        let hide = inactiveView

        guard animated else {
            show.isHidden = false
            show.alpha = 1
            hide.isHidden = true
            return
        }

        show.alpha = 0
        show.isHidden = false
        UIView.animate(withDuration: Constants.toggleDuration, animations: {
            show.alpha = 1
            hide.alpha = 0
        }, completion: { [weak self] _ in
            
            guard let self, hide !== self.activeView else { return }
            hide.isHidden = true
            hide.alpha = 1
        })
    }

    /// Reloads only the view that is currently on screen; the other reloads when toggled.
    private func reloadVisibleContent() {
        if isGridMode {
            articlesGridView.reloadData()
        } else {
            articlesListView.reloadData()
        }
    }

    private func openSearch() {}
    

    // MARK: - Api Call Data
    
    private func fetchArticles(force: Bool = false, completion: (() -> Void)? = nil) {

        guard !isFetching else {
            completion?()
            return
        }

        // First attempt: skip the call if we already know we're offline.
        // Retry / pull to refresh (force = true): always try the API for real.
        if !force && !NetworkMonitor.shared.isConnected {
            presentOffline()
            completion?()
            return
        }

        isFetching = true
        manager.fetchArticles { [weak self] result in
            guard let self else { return }
            self.isFetching = false
            defer { completion?() }

            switch result {
            case .success(let articles):
                self.articles = articles
                self.dismissOffline()
                self.reloadVisibleContent()

            case .failure(let error):
                if self.isOffline(error) {
                    self.presentOffline()
                } else {
                    self.showAlert(title: "Error", message: error.message)
                }
            }
        }
    }

    /// Offline if Reachability says so, or the request itself failed for a connectivity reason.
    private func isOffline(_ error: Error) -> Bool {
        if !NetworkMonitor.shared.isConnected { return true }

        let offlineCodes: Set<URLError.Code> = [
            .notConnectedToInternet,
            .networkConnectionLost,
            .dataNotAllowed,
            .cannotConnectToHost,
            .timedOut
        ]
        if let urlError = error as? URLError {
            return offlineCodes.contains(urlError.code)
        }
        // Your error type may wrap the URLError
        let nsError = error as NSError
        return nsError.domain == NSURLErrorDomain && offlineCodes.contains(URLError.Code(rawValue: nsError.code))
    }

    private func dismissOffline() {
        isShowingOffline = false
        hideOfflineView()
        updateContentVisibility()
    }

    /// Single place that decides which of the list / grid is visible.
    private func updateContentVisibility() {
        articlesListView.isHidden = isShowingOffline || isGridMode
        articlesGridView.isHidden = isShowingOffline || !isGridMode
        articlesListView.alpha = 1
        articlesGridView.alpha = 1
    }

    
    private func refreshArticles() {
        guard NetworkMonitor.shared.isConnected else {
            endRefreshing()
            presentOffline()
            return
        }

        fetchArticles(force: true) { [weak self] in
            self?.endRefreshing()
        }
    }

    private func endRefreshing() {
        articlesListView.refreshControl?.endRefreshing()
        articlesGridView.refreshControl?.endRefreshing()
    }
    
    private func presentOffline() {
        isShowingOffline = true
        updateContentVisibility()
        showOfflineView(below: headerView) { [weak self] done in
            self?.retryFromOffline(done: done)
        }
    }

    private func retryFromOffline(done: @escaping () -> Void) {
        guard NetworkMonitor.shared.isConnected else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { done() }
            return
        }
        fetchArticles(force: true, completion: done)
    }

    // MARK: - Navigation
    private func openDetails(for article: Article) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailsVC = storyboard.instantiateViewController(
            withIdentifier: "ArticalDetailsViewController"
        ) as? ArticalDetailsViewController else {
            assertionFailure("Check the Storyboard ID and class of the details screen")
            return
        }
        guard let nav = navigationController else {
            assertionFailure("The list screen is not embedded in a UINavigationController")
            return
        }
        detailsVC.articleDetail = article
        nav.pushViewController(detailsVC, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ArticalsListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.listCellID,
            for: indexPath
        ) as? ArticalsListTableViewCell else {
            return UITableViewCell()
        }

        let article = articles[indexPath.row]
        cell.selectionStyle = .none
        cell.configureCell(article: article)
        cell.onReadMoreTapped = { [weak self] in
            self?.openDetails(for: article)
        }
        return cell
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension ArticalsListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        articles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.gridCellID,
            for: indexPath
        ) as? ArticalsGridViewCollectionViewCell else {
            return UICollectionViewCell()
        }

        let article = articles[indexPath.item]
        cell.configure(
            title: article.title ?? article.description ?? "",
            imageURLString: article.urlToImage
        )
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openDetails(for: articles[indexPath.item])
    }

    // MARK: Layout: 2 items per row
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = Constants.gridInsets
        let totalSpacing = insets.left + insets.right + Constants.gridSpacing * (Constants.gridColumns - 1)
        let itemWidth = floor((collectionView.bounds.width - totalSpacing) / Constants.gridColumns)
        return CGSize(width: itemWidth,
                      height: ArticalsGridViewCollectionViewCell.height(forWidth: itemWidth))
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        Constants.gridInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.gridSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.gridSpacing
    }
}
