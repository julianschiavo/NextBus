//
//  NWFBCitybusAPI.swift
//  NextBus
//
//  Created by Julian Schiavo on 18/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

protocol API {
    
    // MARK: - Companies
    
    func fetchCompany(id: CompanyID, completion: @escaping (Result<Company, Error>) -> Void)
    
    // MARK: - Routes
    
    func fetchRoutes(companyID: CompanyID, route: String?, urlSession: URLSession, completion: @escaping (Result<OrderedSet<Route>, Error>) -> Void)
    
    // MARK: - Stops
    
    func updateStops(for route: Route, includingCached: Bool, urlSession: URLSession, completion: @escaping (Error?) -> Void)
    func fetchStops(for route: Route, in direction: Direction, urlSession: URLSession, completion: @escaping (Result<OrderedSet<Stop>, Error>) -> Void)
    
    // MARK: - ETAs
    
    func fetchETA(for route: Route, in direction: Direction, stop: Stop, urlSession: URLSession, completion: @escaping (Result<OrderedSet<ETA>, Error>) -> Void)
}

class APIManager {
    
    enum Priority {
        case low
        case normal
        
        var queue: DispatchQueue {
            switch self {
            case .low:
                return DispatchQueue.global(qos: .background)
            case .normal:
                return DispatchQueue.global(qos: .userInteractive)
            }
        }

//        var opQueue: OperationQueue {
//            switch self {
//            case .low:
//                return APIManager.shared.lowPriorityOperationQueue
//            case .normal:
//                return APIManager.shared.normalPriorityOperationQueue
//            }
//        }

        var urlSession: URLSession {
            switch self {
            case .low:
                return APIManager.shared.lowPriorityURLSession
            case .normal:
                return APIManager.shared.highPriorityURLSession
            }
        }

//        var priority: Operation.QueuePriority {
//            switch self {
//            case .low:
//                return .veryLow
//            case .normal:
//                return .veryHigh
//            }
//        }
    }
    
    enum APIError: Error {
        case failedToLoad
        
        var localizedDescription: String {
            switch self {
            case .failedToLoad: return "Failed to load data."
            }
        }
    }
    
    let appGroupFolderURL: URL
    
    let nwfbctbAPI: API = NWFBCTBAPI()
    let nlbAPI: API = NLBAPI()
    
    let backgroundQueue = DispatchQueue.global(qos: .userInteractive)
    
    var lowPriorityURLSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.networkServiceType = .background
        #if os(watchOS)
        config.httpMaximumConnectionsPerHost = 1
        #endif
        return URLSession(configuration: config)
    }()
    
    var highPriorityURLSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.networkServiceType = .responsiveData
        #if os(watchOS)
        config.httpMaximumConnectionsPerHost = 1
        #endif
        return URLSession(configuration: config)
    }()
    
    var lowPriorityOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .background
        #if os(watchOS)
        queue.maxConcurrentOperationCount = 1
        #endif
        return queue
    }()
    var normalPriorityOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    enum Status {
        case fetchStarting(URL?)
        case fetchSuccessful(URL?)
        case fetchFailed(URL?, Error?)
        case decodeSuccessful
        case decodeFailed(URL?, Error?)
        case custom(String)
    }
    
    static func request(ofType type: String, didChangeStatus status: Status) {
        switch status {
        case let .fetchStarting(url):
            print("Starting \(type) request with URL:", url)
        case let .fetchSuccessful(url):
            print("\(type) request (URL: \(url)) finished successfully")
        case let .fetchFailed(url, error):
            print("\(type) request (URL: \(url)) failed with error:", error as Any)
        case .decodeSuccessful:
            print("\(type) decoding finished successfully")
        case let .decodeFailed(url, error):
            print("\(type) decoding failed with URL:", url ?? "", "and error:", error as Any)
        case let .custom(text):
            print("\(type) \(text)")
        }
    }
    
    func sendFileToAppleWatch(fileURL: URL) {
        #if os(iOS)
        WatchSessionManager.shared.sendFile(at: fileURL)
        #endif
    }
    
    func updateData(priority: Priority, completion: @escaping (Error?) -> Void) {
        var error: Error?
        var routes = [Route]()
        
        let group = DispatchGroup()

        for _ in CompanyID.allCases {
            group.enter()
        }
        
        group.notify(queue: priority.queue, execute: {
            completion(error)
            
            #if os(iOS)
            priority.queue.async {
                for route in routes {
                    self.updateStops(for: route, includingCached: false, priority: priority) { _ in }
                }
            }
            #endif
        })

        for companyID in CompanyID.allCases {
            self.fetchCompany(id: companyID, priority: priority) { result in
                switch result {
                case let .success(company):
                    self.cachedCompanies.append(company)
                    self.fetchRoutes(for: companyID, priority: priority) { result in
                        switch result {
                        case let .success(newRoutes):
                            routes.append(contentsOf: newRoutes)
                            group.leave()
                        case let .failure(newError):
                            error = newError
                            group.leave()
                        }
                    }
                case let .failure(newError):
                    error = newError
                    group.leave()
                }
            }
        }
    }
    
    func clearURL(_ url: URL) {
        if FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(at: url)
        }
    }

    // MARK: - Favorites
    
    lazy var favoritesURL = appGroupFolderURL.appendingPathComponent("UserFavorites").appendingPathExtension("json")
    
    func isFavorite(route: Route, direction: Direction, stop: Stop) -> Bool {
        let favorite = Favorite(route: route, direction: direction, stop: stop)
        return isFavorite(favorite: favorite)
    }
    
    func isFavorite(favorite: Favorite) -> Bool {
        guard let data = FileManager.default.contents(atPath: favoritesURL.path),
            let favorites = try? JSONDecoder().decode([Favorite].self, from: data) else { return false }
        return favorites.contains(favorite)
    }
    
    func setFavorite(_ isFavorite: Bool, favorite: Favorite) {
        var favorites = [Favorite]()
        if let data = FileManager.default.contents(atPath: favoritesURL.path), let existingFavorites = try? JSONDecoder().decode([Favorite].self, from: data) {
            favorites = existingFavorites
        }
        
        if isFavorite {
            favorites.append(favorite)
        } else {
            favorites.removeAll { $0 == favorite }
        }
        
        guard let data = try? JSONEncoder().encode(favorites) else { return }
        clearURL(favoritesURL)
        try? data.write(to: favoritesURL, options: .atomic)
        NotificationCenter.default.post(Notification(name: .favoritesChanged))
        sendFileToAppleWatch(fileURL: favoritesURL)
    }
    
    func favorites() -> [(Route, Direction, Stop)] {
        let all = allFavorites()
        var data = [(Route, Direction, Stop)]()
        
        for favorite in all {
            guard let route = routes(for: favorite.companyID)?.first(where: { $0.id == favorite.routeID && $0.name == favorite.routeName }),
                let stop = stops(for: route, in: favorite.direction)?.first(where: { $0.id == favorite.stopID }) else { continue }
            data.append((route, favorite.direction, stop))
        }
        
        return data
    }
    
    private func allFavorites() -> [Favorite] {
        guard let data = FileManager.default.contents(atPath: favoritesURL.path),
            let favorites = try? JSONDecoder().decode([Favorite].self, from: data) else { return [] }
        print("file", favorites)
        return favorites
    }
    
    // MARK: - Companies

    var cachedCompanies: OrderedSet<Company> {
        get {
            guard let data = UserDefaults.shared.data(forKey: "CachedCompanies"),
                let cached = try? JSONDecoder().decode([Company].self, from: data) else { return [] }
            return OrderedSet(cached).removingDuplicates()
        }
        set(companies) {
            backgroundQueue.sync {
                let companies = OrderedSet(companies.contents.sorted { $0.name < $1.name }).removingDuplicates()
                guard let encodedData = try? JSONEncoder().encode(companies.contents) else { return }
                UserDefaults.shared.set(encodedData, forKey: "CachedCompanies")
            }
        }
    }

    func fetchCompany(id: CompanyID, priority: Priority, completion: @escaping (Result<Company, Error>) -> Void) {
        if CompanyID.nwfbctbIDs.contains(id) {
            nwfbctbAPI.fetchCompany(id: id, completion: completion)
        } else if CompanyID.nlbIDs.contains(id) {
            self.nlbAPI.fetchCompany(id: id, completion: completion)
        } else {
            completion(.failure(APIError.failedToLoad))
        }
    }

    // MARK: - Routes
    
    func hasCachedRoutes() -> Bool {
        for companyID in CompanyID.allCases {
            if routes(for: companyID) != nil { return true }
        }
        return false
    }

    func cache(_ routes: OrderedSet<Route>, for companyID: CompanyID, fetchPrices shouldFetchPrices: Bool = true) {
        if shouldFetchPrices {
            fetchPricesAndRecacheRoutes(routes: routes, for: companyID)
        }
        
        let oldRoutes = self.routes(for: companyID) ?? []
        
        var updatedRoutes = [Route]()
        for route in routes {
            guard route.fare == nil else {
                updatedRoutes.append(route)
                return
            }
            if let oldRoute = oldRoutes.first(where: { $0.id == route.id && $0.name == route.name }) {
                var updatedRoute = route
                updatedRoute.fare = oldRoute.fare
                updatedRoute.holidayFare = oldRoute.holidayFare
                updatedRoutes.append(updatedRoute)
            } else {
                updatedRoutes.append(route)
            }
        }
        let sortedRoutes = updatedRoutes.sorted { $0.name < $1.name }
        
        let url = appGroupFolderURL.appendingPathComponent("CachedRoutes\(companyID.rawValue)").appendingPathExtension("json")
        print("Caching", url)
        
        guard let data = try? JSONEncoder().encode(sortedRoutes) else { return }
        clearURL(url)
        try? data.write(to: url, options: .atomic)
        sendFileToAppleWatch(fileURL: url)
    }
    
    func routes(for companyID: CompanyID) -> OrderedSet<Route>? {
        let url = appGroupFolderURL.appendingPathComponent("CachedRoutes\(companyID.rawValue)").appendingPathExtension("json")
        guard let data = FileManager.default.contents(atPath: url.path),
            let routes = try? JSONDecoder().decode([Route].self, from: data) else { return nil }
        return OrderedSet(routes)
    }

    private func fetchRoutes(for companyID: CompanyID, route: String? = nil, priority: Priority, completion: @escaping (Result<OrderedSet<Route>, Error>) -> Void) {
        priority.queue.async {
            if CompanyID.nwfbctbIDs.contains(companyID) {
                self.nwfbctbAPI.fetchRoutes(companyID: companyID, route: route, urlSession: priority.urlSession, completion: completion)
            } else if CompanyID.nlbIDs.contains(companyID) {
                self.nlbAPI.fetchRoutes(companyID: companyID, route: route, urlSession: priority.urlSession, completion: completion)
            } else {
                completion(.failure(APIError.failedToLoad))
                return
            }
        }
    }
    
    private func fetchPricesAndRecacheRoutes(routes: OrderedSet<Route>, for companyID: CompanyID) {
        APIManager.request(ofType: "PriceUpdate", didChangeStatus: .fetchStarting(nil))
        
        var updatedRoutes = OrderedSet<Route>()
        
        var count = 0
        let totalCount = routes.count
        
        let group = DispatchGroup()
        
        group.enter()
        group.notify(queue: backgroundQueue, execute: {
            APIManager.request(ofType: "PriceUpdate", didChangeStatus: .fetchSuccessful(nil))
            self.cache(updatedRoutes, for: companyID, fetchPrices: false)
        })
        
        for route in routes {
            group.enter()
            fetchPrice(companyID: companyID, route: route, urlSession: Priority.low.urlSession) { fare in
                let cleanedFare = fare?.replacingOccurrences(of: "$", with: "")
                var updatedRoute = route
                updatedRoute.fare = cleanedFare
                updatedRoute.holidayFare = cleanedFare
                updatedRoutes.append(updatedRoute)
                group.leave()
                
                count += 1
                APIManager.request(ofType: "PriceUpdate", didChangeStatus: .custom("finished \(count)/\(totalCount)"))
            }
        }
        
        group.leave()
    }

    // MARK: - Stops

    func hasCachedStops(for route: Route, in direction: Direction) -> Bool {
        let url = appGroupFolderURL.appendingPathComponent("CachedStops\(route.id)\(route.name)\(direction.rawValue)").appendingPathExtension("json")
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    func hasValidCachedStops(for route: Route, in direction: Direction) -> Bool {
        return hasCachedStops(for: route, in: direction) && stops(for: route, in: direction)?.isEmpty == false
    }
    
    func cache(_ stops: OrderedSet<Stop>, for route: Route, in direction: Direction) {
        defer {
            cacheNameIndex(for: stops, route: route, direction: direction)
        }

        let url = appGroupFolderURL.appendingPathComponent("CachedStops\(route.id)\(route.name)\(direction.rawValue)").appendingPathExtension("json")
        print("Caching", url)
        
        guard let data = try? JSONEncoder().encode(stops.contents) else { return }
        clearURL(url)
        try? data.write(to: url, options: .atomic)
        sendFileToAppleWatch(fileURL: url)
    }
    
    fileprivate func cacheNameIndex(for stops: OrderedSet<Stop>, route: Route, direction: Direction) {
        let stopNameIndex = stops.contents.map { $0.englishName.lowercased() + $0.simplifiedChineseName.lowercased() + $0.traditionalChineseName.lowercased() }.joined()

        let url = appGroupFolderURL.appendingPathComponent("CachedStopNameIndex\(route.id)\(route.name)\(direction.rawValue)").appendingPathExtension("txt")
        clearURL(url)
        try? stopNameIndex.write(to: url, atomically: true, encoding: .utf8)
        sendFileToAppleWatch(fileURL: url)
    }
    
    func stops(for route: Route, in direction: Direction) -> OrderedSet<Stop>? {
        stops(forRouteID: route.id, routeName: route.name, in: direction)
    }
    
    func stopNameIndex(for route: Route, in direction: Direction) -> String {
        stopNameIndex(forRouteID: route.id, routeName: route.name, in: direction)
    }
    
    func stops(for route: INRoute, in direction: Direction) -> OrderedSet<Stop>? {
        guard let identifier = route.identifier, let name = route.name else { return nil }
        return stops(forRouteID: identifier, routeName: name, in: direction)
    }
    
    private func stopNameIndex(forRouteID routeID: String, routeName: String, in direction: Direction) -> String {
        let url = appGroupFolderURL.appendingPathComponent("CachedStopNameIndex\(routeID)\(routeName)\(direction.rawValue)").appendingPathExtension("txt")
        guard let data = FileManager.default.contents(atPath: url.path), let stopNameIndex = String(data: data, encoding: .utf8) else { return "" }
        return stopNameIndex
    }
    
    private func stops(forRouteID routeID: String, routeName: String, in direction: Direction) -> OrderedSet<Stop>? {
        let url = appGroupFolderURL.appendingPathComponent("CachedStops\(routeID)\(routeName)\(direction.rawValue)").appendingPathExtension("json")
        guard let data = FileManager.default.contents(atPath: url.path),
            let stops = try? JSONDecoder().decode([Stop].self, from: data) else { return nil }
        return OrderedSet(stops)
    }

    func updateStops(for route: Route, includingCached includeCached: Bool = true, priority: Priority, completion: @escaping (Error?) -> Void) {
        print("updatest", includeCached, hasCachedStops(for: route, in: .inbound))
        if CompanyID.nwfbctbIDs.contains(route.companyID) {
            self.nwfbctbAPI.updateStops(for: route, includingCached: includeCached, urlSession: priority.urlSession, completion: completion)
        } else if CompanyID.nlbIDs.contains(route.companyID) {
            self.nlbAPI.updateStops(for: route, includingCached: includeCached, urlSession: priority.urlSession, completion: completion)
        } else {
            completion(APIError.failedToLoad)
        }
    }

    func fetchStops(for route: Route, in direction: Direction, priority: Priority, completion: @escaping (Result<OrderedSet<Stop>, Error>) -> Void) {
        if CompanyID.nwfbctbIDs.contains(route.companyID) {
            self.nwfbctbAPI.fetchStops(for: route, in: direction, urlSession: priority.urlSession, completion: completion)
        } else if CompanyID.nlbIDs.contains(route.companyID) {
            self.nlbAPI.fetchStops(for: route, in: direction, urlSession: priority.urlSession, completion: completion)
        } else {
            completion(.failure(APIError.failedToLoad))
        }
    }

    // MARK: - ETA

    func fetchETA(for route: Route, in direction: Direction, stop: Stop, priority: Priority, completion: @escaping (Result<OrderedSet<ETA>, Error>) -> Void) {
        if CompanyID.nwfbctbIDs.contains(route.companyID) {
            self.nwfbctbAPI.fetchETA(for: route, in: direction, stop: stop, urlSession: priority.urlSession, completion: completion)
        } else if CompanyID.nlbIDs.contains(route.companyID) {
            self.nlbAPI.fetchETA(for: route, in: direction, stop: stop, urlSession: priority.urlSession, completion: completion)
        } else {
            completion(.failure(APIError.failedToLoad))
        }
    }
    
    // MARK: - Price
    
    func fetchPrice(companyID: CompanyID, route: Route, completion: @escaping (String?) -> Void) {
        fetchPrice(companyID: companyID, route: route, urlSession: Priority.normal.urlSession, completion: completion)
    }
    
    func fetchPrice(companyID: CompanyID, route: Route, urlSession: URLSession, completion: @escaping (String?) -> Void) {
        let type = "FetchPrice"
        
        let urlString = "https://api.data.gov.hk/v1/filter"
        guard let baseURL = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let queryItem = """
        {"resource":"http://static.data.gov.hk/td/routes-and-fares/ROUTE_BUS.mdb","section":1,"format":"json","filters":[[6,"eq",["\(route.name)"]]]}
        """
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "q", value: queryItem)]
        guard let url = components?.url else { return }
        APIManager.request(ofType: type, didChangeStatus: .fetchStarting(url))
        
        let task = urlSession.downloadTask(with: url) { localURL, response, error in
            guard let localURL = localURL, error == nil else {
                APIManager.request(ofType: type, didChangeStatus: .fetchFailed(url, error))
                completion(nil)
                return
            }
            APIManager.request(ofType: type, didChangeStatus: .fetchSuccessful(url))
            
            guard let data = FileManager.default.contents(atPath: localURL.path) else {
                completion(nil)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let rawPriceData = try decoder.decode(RawPriceData.self, from: data)
                let priceDataArray = rawPriceData.convertToPriceData()
                
                guard let priceData = priceDataArray.first(where: { $0.companyID.contains(companyID.rawValue) }) else {
                    completion(nil)
                    return
                }
                APIManager.request(ofType: type, didChangeStatus: .decodeSuccessful)
                completion(priceData.fullFare)
            } catch {
                APIManager.request(ofType: type, didChangeStatus: .decodeFailed(url, error))
                completion(nil)
            }
        }
        task.resume()
    }
    
    // MARK: - Singleton
    
    static var shared = APIManager()
    private init() {
        guard let folder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.julianschiavo.nextbus") else {
            fatalError("Failed to find app group folder")
        }
        appGroupFolderURL = folder
    }
    
    func start(completion: @escaping () -> Void) {
        updateData(priority: .low) { _ in
            completion()
        }
    }
}
