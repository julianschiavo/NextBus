//
//  RouteStopDetailsViewController.swift
//  NextBus
//
//  Created by Julian Schiavo on 19/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import UIKit

protocol RouteStopDetailsViewControllerDataSourceDelegate: AnyObject {
    var route: Route { get }
    var direction: Direction { get }
    var stop: Stop { get }
    var etas: [ETA]? { get }
}

class RouteStopDetailsViewController: UITableViewController, RouteStopDetailsViewControllerDataSourceDelegate {
    
    enum Section: Hashable {
        case info
        case etas
        case map
        
        var title: String? {
            switch self {
            case .info: return nil
            case .etas: return Localizations.detailsArrivingSoonHeader
            case .map: return Localizations.detailsMapHeader
            }
        }
    }
    
    enum Item: Hashable {
        case info
        case tokens
        case loading
        case eta(ETA)
        case map
    }
    
    var route: Route
    var direction: Direction
    var stop: Stop
    var etas: [ETA]?
    
    var timer: Timer?
    var favoriteBarButtonItem: UIBarButtonItem?
    
    init(route: Route, direction: Direction, stop: Stop) {
        self.route = route
        self.direction = direction
        self.stop = stop
        super.init(style: .insetGrouped)
        updateData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = stop.name
        navigationItem.largeTitleDisplayMode = .never
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(updateData), for: .valueChanged)
        
        favoriteBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(toggleFavorite))
        navigationItem.rightBarButtonItem = favoriteBarButtonItem
        updateFavoriteButton()
        
        tableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: LoadingTableViewCell.reuseIdentifier)
        tableView.register(RouteTableViewCell.self, forCellReuseIdentifier: RouteTableViewCell.reuseIdentifier)
        tableView.register(TokensTableViewCell.self, forCellReuseIdentifier: TokensTableViewCell.reuseIdentifier)
        tableView.register(ETATableViewCell.self, forCellReuseIdentifier: ETATableViewCell.reuseIdentifier)
        tableView.register(MapTableViewCell.self, forCellReuseIdentifier: MapTableViewCell.reuseIdentifier)
        setupDataSource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateDataInBackground), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    @objc func updateData() {
        fetchUpdatedData(displayErrorAlert: true)
    }
    
    @objc func updateDataInBackground() {
        fetchUpdatedData(displayErrorAlert: false)
    }
    
    func fetchUpdatedData(displayErrorAlert: Bool) {
        APIManager.shared.fetchETA(for: route, in: direction, stop: stop, priority: .normal) { [weak self] result in
            var error: Error?
            
            switch result {
            case let .success(etas):
                self?.etas = etas.contents.sorted { $0.date ?? Date() < $1.date ?? Date() }
            case let .failure(newError):
                error = newError
            }
            
            print(error as Any)
            
            DispatchQueue.main.async {
                self?.dataSource.reload()
                self?.refreshControl?.endRefreshing()
                
                if let error = error, displayErrorAlert {
                    let alertController = UIAlertController(title: Localizations.error, message: error.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: Localizations.ok, style: .cancel, handler: nil))
                    alertController.addAction(UIAlertAction(title: Localizations.retry, style: .default, handler: { [weak self] _ in self?.updateData() }))
                    self?.present(alertController, animated: true)
                }
            }
        }
    }
    
    // MARK: - Favorite
    
    @objc func toggleFavorite() {
        let favorite = Favorite(route: route, direction: direction, stop: stop)
        if APIManager.shared.isFavorite(favorite: favorite) {
            APIManager.shared.setFavorite(false, favorite: favorite)
        } else {
            APIManager.shared.setFavorite(true, favorite: favorite)
        }
        
        updateFavoriteButton()
    }
    
    func updateFavoriteButton() {
        let favorite = Favorite(route: route, direction: direction, stop: stop)
        if APIManager.shared.isFavorite(favorite: favorite) {
            favoriteBarButtonItem?.image = UIImage(systemName: "heart.fill")
        } else {
            favoriteBarButtonItem?.image = UIImage(systemName: "heart")
        }
    }
    
    // MARK: - Data Source
    
    var dataSource: DataSource!
    
    func setupDataSource() {
        dataSource = DataSource(delegate: self, route: route, direction: direction, stop: stop, tableView: tableView)
        dataSource.reload()
    }
    
    class DataSource: UITableViewDiffableDataSource<Section, Item> {
        
        weak var delegate: RouteStopDetailsViewControllerDataSourceDelegate?
        
        var route: Route
        var stop: Stop
        
        let unknownETA: ETA
        let dateFormatter = RelativeDateTimeFormatter()
        
        var snapshot: NSDiffableDataSourceSnapshot<Section, Item>!
        
        func getSection(for section: Int) -> Section? {
            snapshot?.sectionIdentifiers[section]
        }
        
        func getItem(at indexPath: IndexPath) -> Item? {
            itemIdentifier(for: indexPath)
        }
        
        func lastUpdatedText(for eta: ETA) -> String {
            dateFormatter.string(for: eta.generated) ?? ""
        }
        
        init(delegate: RouteStopDetailsViewControllerDataSourceDelegate, route: Route, direction: Direction, stop: Stop, tableView: UITableView) {
            self.route = route
            self.stop = stop
            unknownETA = ETA.unknown(for: route, direction: direction)
            self.delegate = delegate
            super.init(tableView: tableView) { tableView, indexPath, item -> UITableViewCell? in
                
                func getCell<T: ReusableTableViewCell>(ofType type: T.Type) -> T? {
                    tableView.dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as? T
                }
                
                switch item {
                case .info:
                    guard let cell = getCell(ofType: RouteTableViewCell.self) else { return nil }
                    cell.setup(route: route, direction: direction, origin: stop.name, style: .large)
                    return cell
                case .tokens:
                    guard let cell = getCell(ofType: TokensTableViewCell.self) else { return nil }
                    let tokens = Token.tokens(route: route, stop: stop)
                    cell.setup(tokens: tokens)
                    return cell
                case let .eta(eta):
                    guard let cell = getCell(ofType: ETATableViewCell.self) else { return nil }
                    cell.setup(eta: eta)
                    return cell
                case .loading:
                    return getCell(ofType: LoadingTableViewCell.self)
                case .map:
                    guard let cell = getCell(ofType: MapTableViewCell.self) else { return nil }
                    cell.setup(name: stop.name, latitude: stop.latitude, longitude: stop.longitude)
                    return cell
                }
            }
        }
        
        func reload(fromCache: Bool = false) {
            guard !fromCache else {
                apply(snapshot, animatingDifferences: true)
                return
            }
            
            snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            
            snapshot.appendSections([.info])
            snapshot.appendItems([.info], toSection: .info)
            if Token.tokens(route: route, stop: stop).isEmpty == false {
                snapshot.appendItems([.tokens], toSection: .info)
            }
 
            snapshot.appendSections([.etas])
            if let etas = delegate?.etas {
                if etas.isEmpty {
                    snapshot.appendItems([.eta(unknownETA)], toSection: .etas)
                } else {
                    snapshot.appendItems(etas.map { .eta($0) }, toSection: .etas)
                }
            } else {
                snapshot.appendItems([.loading], toSection: .etas)
            }
            
            snapshot.appendSections([.map])
            snapshot.appendItems([.map], toSection: .map)
            
            apply(snapshot, animatingDifferences: true)
        }
        
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            getSection(for: section)?.title
        }

        override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
            if getSection(for: section) == .etas, let eta = delegate?.etas?.first {
                let text = lastUpdatedText(for: eta)
                return Localizations.detailsLastUpdatedFooter(text)
            } else if getSection(for: section) == .map {
                return Localizations.detailsMapFooter
            }
            return nil
        }
    }
}
