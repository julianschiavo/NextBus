//
//  RouteStopsViewController.swift
//  NextBus
//
//  Created by Julian Schiavo on 19/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import CoreLocation
import SwiftUI
import UIKit

class RouteStopsViewController: UITableViewController {
    
    enum Section: Hashable {
        case info
        case loading
        case nearbyStops
        case allStops
        
        var title: String? {
            switch self {
            case .nearbyStops: return Localizations.nearbyBusStopsHeader
            case .allStops: return Localizations.allBusStopsHeader
            default: return nil
            }
        }
    }
    
    enum Item: Hashable {
        case info
        case tokens
        case loading
        case stop(Stop)
    }
    
    var route: Route
    var direction: Direction
    
    init(route: Route, direction: Direction) {
        self.route = route
        self.direction = direction
        super.init(style: .insetGrouped)
        
        updateData()
        
        title = Localizations.routeTowards(routeName: route.localizedName, destination: route.localizedDestination)
        navigationItem.largeTitleDisplayMode = .never
        
//        refreshControl = UIRefreshControl()
//        refreshControl?.addTarget(self, action: #selector(updateData), for: .valueChanged)
        
        tableView.register(RouteTableViewCell.self, forCellReuseIdentifier: RouteTableViewCell.reuseIdentifier)
//        tableView.register(TokensTableViewCell.self, forCellReuseIdentifier: TokensTableViewCell.reuseIdentifier)
        tableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: LoadingTableViewCell.reuseIdentifier)
        tableView.register(StopTableViewCell.self, forCellReuseIdentifier: StopTableViewCell.reuseIdentifier)
        setupDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func updateData() {
//        APIManager.shared.updateStops(for: route, priority: .normal) { [weak self] error in
//            DispatchQueue.main.async {
//                self?.dataSource?.reload()
//                self?.refreshControl?.endRefreshing()
//
//                if let error = error {
//                    let alertController = UIAlertController(title: Localizations.error, message: error.localizedDescription, preferredStyle: .alert)
//                    alertController.addAction(UIAlertAction(title: Localizations.ok, style: .cancel, handler: nil))
//                    alertController.addAction(UIAlertAction(title: Localizations.retry, style: .default, handler: { [weak self] _ in self?.updateData() }))
//                    self?.present(alertController, animated: true)
//                }
//            }
//        }
    }
    
    // MARK: - Data Source
    
    var dataSource: DataSource!
    
    func setupDataSource() {
        dataSource = DataSource(route: route, direction: direction, tableView: tableView)
        dataSource.reload()
    }
    
    class DataSource: UITableViewDiffableDataSource<Section, Item>, CLLocationManagerDelegate {
        
        var route: Route
        var direction: Direction
        var userLocation: CLLocation
        
        let dateFormatter = RelativeDateTimeFormatter()
        let locationManager = CLLocationManager()
        
        var snapshot: NSDiffableDataSourceSnapshot<Section, Item>!
        
        func getSection(for section: Int) -> Section? {
            snapshot?.sectionIdentifiers[section]
        }
        
        func getItem(at indexPath: IndexPath) -> Item? {
            itemIdentifier(for: indexPath)
        }
        
        func lastUpdatedText(for stop: Stop) -> String {
            dateFormatter.string(for: stop.lastUpdated) ?? ""
        }
        
        init(route: Route, direction: Direction, tableView: UITableView) {
            self.route = route
            self.direction = direction
            self.userLocation = CLLocation(latitude: 0, longitude: 0)
            super.init(tableView: tableView) { tableView, indexPath, item -> UITableViewCell? in
                
                func getCell<T: ReusableTableViewCell>(ofType type: T.Type) -> T? {
                    tableView.dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as? T
                }
                
                switch item {
                case .info:
                    guard let cell = getCell(ofType: RouteTableViewCell.self) else { return nil }
                    cell.setup(route: route, direction: direction, style: .large)
                    return cell
//                case .tokens:
//                    guard let cell = getCell(ofType: TokensTableViewCell.self) else { return nil }
//                    let tokens = Token.tokens(route: route)
//                    cell.setup(tokens: tokens)
//                    return cell
                case let .stop(stop):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: StopTableViewCell.reuseIdentifier, for: indexPath) as? StopTableViewCell else { return nil }
                    cell.setup(stop: stop)
                    return cell
                case .loading, .tokens:
                    return getCell(ofType: LoadingTableViewCell.self)
                }
            }
            
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        
        deinit {
            locationManager.stopUpdatingLocation()
        }
        
        func reload() {
            snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            
            snapshot.appendSections([.info])
            snapshot.appendItems([.info], toSection: .info)
            if Token.tokens(route: route).isEmpty == false {
                snapshot.appendItems([.tokens], toSection: .info)
            }
            
//            if let stops = APIManager.shared.stops(for: route, in: direction) {
//                var allItems = [Item]()
//                var nearbyItems = [(item: Item, distance: CLLocationDistance)]()
//
//                for stop in stops.contents {
//                    let item = Item.stop(stop)
//                    let location = CLLocation(latitude: stop.latitude, longitude: stop.longitude)
//                    let distance = userLocation.distance(from: location)
//                    if distance < 400 {
//                        nearbyItems.append((item, distance))
//                    } else {
//                        allItems.append(item)
//                    }
//                }
//
//                nearbyItems.sort { $0.distance < $1.distance }
//
//                if !nearbyItems.isEmpty {
//                    snapshot.appendSections([.nearbyStops])
//                    snapshot.appendItems(nearbyItems.map { $0.item }, toSection: .nearbyStops)
//                }
//
//                snapshot.appendSections([.allStops])
//                snapshot.appendItems(allItems, toSection: .allStops)
//            } else {
//                snapshot.appendSections([.loading])
//                snapshot.appendItems([.loading])
//            }
            
            apply(snapshot, animatingDifferences: true)
        }
        
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            getSection(for: section)?.title
        }
        
//        override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//            guard getSection(for: section) == .allStops, let stop = APIManager.shared.stops(for: route, in: direction)?.first else { return nil }
//            return Localizations.detailsLastUpdatedFooter(lastUpdatedText(for: stop))
//        }
        
        // MARK: - Locations
        
        func requestLocation() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let mostRecentLocation = locations.last else { return }
            userLocation = mostRecentLocation
            reload()
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = dataSource.getItem(at: indexPath) else { return }
        
        switch item {
        case let .stop(stop):
//            let viewController = RouteStopDetailsViewController(route: route, direction: direction, stop: stop)
//            let viewController = UIHostingController(rootView: StopDetail(route: route, direction: direction, stop: stop))
//            navigationController?.pushViewController(viewController, animated: true)
            navigationController?.pushViewController(UIHostingController(rootView: BusDetail(route: route, direction: direction)), animated: true)
        case .loading:
            updateData()
        default:
            return
        }
    }
    
    // MARK: - Context Menus
    
//    func contextMenu(for stop: Stop) -> UIMenu {
//        let favorite = Favorite(route: route, direction: direction, stop: stop)
//
//        var favoriteAction: UIAction
//        if APIManager.shared.isFavorite(favorite: favorite) {
//            favoriteAction = UIAction(title: Localizations.unfavoriteButton, image: UIImage(systemName: "heart.slash")) { [weak self] _ in
//                APIManager.shared.setFavorite(false, favorite: favorite)
//                self?.dataSource.reload()
//            }
//        } else {
//            favoriteAction = UIAction(title: Localizations.favoriteButton, image: UIImage(systemName: "heart")) { [weak self] _ in
//                APIManager.shared.setFavorite(true, favorite: favorite)
//                self?.dataSource.reload()
//            }
//        }
//
//        return UIMenu(title: "", children: [favoriteAction])
//    }
//
//    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        guard let item = dataSource.getItem(at: indexPath) else { return nil }
//        switch item {
//        case let .stop(stop):
//            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ -> UIMenu? in
//                self?.contextMenu(for: stop)
//            }
//        default:
//            return nil
//        }
//    }
}
