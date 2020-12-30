//
//  ContentView.swift
//  NextBus
//
//  Created by Julian Schiavo on 18/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController, UISearchResultsUpdating {
    
    enum Section: Hashable {
        case loading
        case favorites
        case spacer
        case companyFilters
        case company(Company)
        
        var title: String? {
            switch self {
            case .favorites: return Localizations.favoritesHeader
            case .companyFilters: return Localizations.shownCompaniesHeader
            case let .company(company): return company.name
            default: return nil
            }
        }
    }
    
    enum Item: Hashable {
        case loading
        case favorite(Route, Direction, Stop)
        case companyFilter(Company)
        case route(Route, Direction)
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    init() {
        super.init(style: .insetGrouped)
        
        title = Localizations.nextBus
        
        setupNavigationBarAppearance()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(updateData), for: .valueChanged)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Localizations.searchBarText
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.searchTextField.tintColor = .systemPink
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        let supportBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(supportButtonTapped))
        navigationItem.rightBarButtonItem = supportBarButtonItem
        
        tableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: LoadingTableViewCell.reuseIdentifier)
        tableView.register(CompanyFilterTableViewCell.self, forCellReuseIdentifier: CompanyFilterTableViewCell.reuseIdentifier)
        tableView.register(RouteTableViewCell.self, forCellReuseIdentifier: RouteTableViewCell.reuseIdentifier)
        setupDataSource()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .companyIsShownChanged, object: nil)
        
        APIManager.shared.start { [weak self] in
            DispatchQueue.main.async {
                self?.reload()
                self?.refreshControl?.endRefreshing()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarAppearance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupNavigationBarAppearance()
    }
    
    func setupNavigationBarAppearance() {
        let color = UIColor(red: 222/255, green: 41/255, blue: 16/255, alpha: 1)
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.configureWithOpaqueBackground()
        barAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        barAppearance.backgroundColor = color
        navigationItem.standardAppearance = barAppearance
        navigationItem.compactAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
        
        guard let image = UIImage(named: "HongKongFlag"),
            let navigationBarSize = navigationController?.navigationBar.frame.size else { return }
        let resizedImage = image.imageWith(newWidth: navigationBarSize.width, inset: 40, backgroundColor: color)
        let resizableImage = resizedImage.resizableImage(withCapInsets: .zero, resizingMode: .tile)
        
        let largeBarAppearance = UINavigationBarAppearance()
        largeBarAppearance.configureWithOpaqueBackground()
        largeBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.preferredFont(for: .largeTitle, weight: .heavy).rounded]
        largeBarAppearance.backgroundColor = color
        largeBarAppearance.backgroundImage = resizableImage
        navigationItem.scrollEdgeAppearance = largeBarAppearance
    }
    
    @objc func updateData() {
        APIManager.shared.updateData(priority: .normal) { [weak self] error in
            DispatchQueue.main.async {
                self?.reload()
                self?.refreshControl?.endRefreshing()
                
                if let error = error {
                    let alertController = UIAlertController(title: Localizations.error, message: error.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: Localizations.ok, style: .cancel, handler: nil))
                    alertController.addAction(UIAlertAction(title: Localizations.retry, style: .default, handler: { [weak self] _ in self?.updateData() }))
                    self?.present(alertController, animated: true)
                }
            }
        }
    }
    
    // MARK: - Data Source
    
    var dataSource: DataSource!
    
    func setupDataSource() {
        dataSource = DataSource(tableView: tableView)
        reload()
    }
    
    class DataSource: UITableViewDiffableDataSource<Section, Item> {
        
        var snapshot: NSDiffableDataSourceSnapshot<Section, Item>!
        
        func getSection(for section: Int) -> Section? {
            snapshot?.sectionIdentifiers[section]
        }
        
        func getItem(at indexPath: IndexPath) -> Item? {
            itemIdentifier(for: indexPath)
        }
        
        init(tableView: UITableView) {
            super.init(tableView: tableView) { tableView, indexPath, item -> UITableViewCell? in
                
                func getCell<T: ReusableTableViewCell>(ofType type: T.Type) -> T? {
                    tableView.dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as? T
                }
                
                switch item {
                case .loading:
                    return getCell(ofType: LoadingTableViewCell.self)
                case let .favorite(route, direction, stop):
                    guard let cell = getCell(ofType: RouteTableViewCell.self) else { return nil }
                    cell.setup(route: route, direction: direction, origin: stop.name, isFavorite: true)
                    return cell
                case let .route(route, direction):
                    guard let cell = getCell(ofType: RouteTableViewCell.self) else { return nil }
                    cell.setup(route: route, direction: direction)
                    return cell
                case let .companyFilter(company):
                    guard let cell = getCell(ofType: CompanyFilterTableViewCell.self) else { return nil }
                    cell.setup(company: company)
                    return cell
                }
            }
        }
        
        func createItems(from route: Route) -> [Item] {
            if route.isOneWay {
                return [Item.route(route, .oneWay)]
            } else {
                return [Item.route(route, .inbound), Item.route(route, .outbound)]
            }
        }
        
        func reload(searchText: String?) {
//            DispatchQueue.global(qos: .userInteractive).async {
//                let favoriteRoutes = APIManager.shared.favoriteRoutes().contents
//                var companyRoutes = [CompanyID: [Route]]()
//                
//                if let searchText = searchText, !searchText.isEmpty {
//                    for company in APIManager.shared.cachedCompanies {
//                        guard let routes = APIManager.shared.routes(for: company)?.contents else { return }
//                        companyRoutes[company.id] = routes.filter { $0.matches(searchText) }
//                    }
//                } else {
//                    for company in APIManager.shared.cachedCompanies {
//                        guard let routes = APIManager.shared.nonFavoriteRoutes(for: company)?.contents else { return }
//                        companyRoutes[company.id] = routes
//                    }
//                }
//                
//                DispatchQueue.main.async {
//                    self.snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
//                    
//                    defer {
//                        self.apply(self.snapshot, animatingDifferences: true)
//                    }
//                    
//                    guard APIManager.shared.hasCachedRoutes() else {
//                        self.snapshot.appendSections([.loading])
//                        self.snapshot.appendItems([.loading], toSection: .loading)
//                        return
//                    }
//                    
//                    if let searchText = searchText, !searchText.isEmpty {
//                        for company in APIManager.shared.cachedCompanies {
//                            guard let routes = companyRoutes[company.id] else { continue }
//                            let items = routes.flatMap(self.createItems)
//                            self.snapshot.appendSections([.company(company)])
//                            self.snapshot.appendItems(items, toSection: .company(company))
//                        }
//                        return
//                    }
//                    
//                    let favoriteItems = favoriteRoutes.flatMap { self.createItems(from: $0) }
//                    self.snapshot.appendSections([.favoriteRoutes])
//                    self.snapshot.appendItems(favoriteItems, toSection: .favoriteRoutes)
//                    
//                    self.snapshot.appendSections([.spacer, .companyFilters])
//                    let companyFilters = APIManager.shared.cachedCompanies.map { Item.companyFilter($0) }
//                    self.snapshot.appendItems(companyFilters, toSection: .companyFilters)
//                    
//                    for company in APIManager.shared.cachedCompanies where company.isShown {
//                        guard let routes = companyRoutes[company.id] else { continue }
//                        let items = routes.flatMap(self.createItems)
//                        self.snapshot.appendSections([.company(company)])
//                        self.snapshot.appendItems(items, toSection: .company(company))
//                    }
//                    
//                }
//            }
            
            snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            
            defer {
                apply(snapshot, animatingDifferences: true)
            }
            
            guard APIManager.shared.hasCachedRoutes() else {
                snapshot.appendSections([.loading])
                snapshot.appendItems([.loading], toSection: .loading)
                return
            }

            if let searchText = searchText, !searchText.isEmpty {
                for company in APIManager.shared.cachedCompanies {
                    guard let routes = APIManager.shared.routes(for: company.id) else { continue }
                    let filteredRoutes = routes.contents.filter { $0.matches(searchText) }
                    let items = filteredRoutes.flatMap { createItems(from: $0) }
                    
                    snapshot.appendSections([.company(company)])
                    snapshot.appendItems(items, toSection: .company(company))
                }
            } else {
                let favorites = APIManager.shared.favorites().map { Item.favorite($0.0, $0.1, $0.2) }
                snapshot.appendSections([.favorites])
                snapshot.appendItems(favorites, toSection: .favorites)

                snapshot.appendSections([.spacer, .companyFilters])
                
                for company in APIManager.shared.cachedCompanies {
                    snapshot.appendItems([.companyFilter(company)], toSection: .companyFilters)
                    
                    if company.isShown, let routes = APIManager.shared.routes(for: company.id) {
                        let items = routes.contents.flatMap { createItems(from: $0) }
                        snapshot.appendSections([.company(company)])
                        snapshot.appendItems(items, toSection: .company(company))
                    }
                }
            }
        }
        
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            getSection(for: section)?.title
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = dataSource.getItem(at: indexPath) else { return }
        
        switch item {
        case let .favorite(route, direction, stop):
            let viewController = RouteStopDetailsViewController(route: route, direction: direction, stop: stop)
            navigationController?.pushViewController(viewController, animated: true)
        case let .route(route, direction):
            let viewController = RouteStopsViewController(route: route, direction: direction)
            navigationController?.pushViewController(viewController, animated: true)
        case let .companyFilter(company):
            company.setIsShown(!company.isShown)
            reload()
        case .loading:
            updateData()
        }
    }
    
    // MARK: - UISearchResultsUpdating
    
    @objc func reload() {
        dataSource.reload(searchText: searchController.searchBar.text?.lowercased())
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        reload()
    }
    
    // MARK: - Support
    
    @objc func supportButtonTapped() {
        let okAction = UIAlertAction(title: Localizations.supportContactYesButton, style: .default) { _ in
            FeedbackAssistant.shared.createNewSupportRequest(on: self)
        }
        
        let cancelAction = UIAlertAction(title: Localizations.cancel, style: .cancel) { _ in
            return
        }
        
        let alertController = UIAlertController(title: Localizations.supportContactTitle, message: Localizations.supportContactText, preferredStyle: .alert)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}
