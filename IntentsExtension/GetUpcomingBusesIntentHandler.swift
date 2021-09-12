//
//  GetUpcomingBusesIntentHandler.swift
//  IntentsExtension
//
//  Created by Julian Schiavo on 14/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Intents

class GetUpcomingBusesIntentHandler: NSObject, GetUpcomingBusesIntentHandling {
    
    private let formatter = RelativeDateTimeFormatter()
    
    override init() {
        super.init()
        formatter.formattingContext = .middleOfSentence
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Source
    
    func resolveSource(for intent: GetUpcomingBusesIntent, with completion: @escaping (INSourceResolutionResult) -> Void) {
        guard intent.source != .unknown else {
            completion(.confirmationRequired(with: .favorites))
            return
        }
        
        completion(.success(with: intent.source))
    }
    
    // MARK: - Route
    
    func provideRouteOptionsCollection(for intent: GetUpcomingBusesIntent, with completion: @escaping (INObjectCollection<INRoute>?, Error?) -> Void) {
        switch intent.source {
        case .favorites:
            provideFavoritesOptionsCollection(with: completion)
        case .recents:
            provideRecentsOptionsCollection(with: completion)
        default:
            provideRouteOptionsCollection(with: completion)
        }
    }
    
    private func provideFavoritesOptionsCollection(with completion: @escaping (INObjectCollection<INRoute>?, Error?) -> Void) {
        Task {
            let favorites = await Store.shared.favorites.load()
            let collection = INObjectCollection(items: favorites.map(\.route).map(\.intent))
            completion(collection, nil)
        }
    }
    
    private func provideRecentsOptionsCollection(with completion: @escaping (INObjectCollection<INRoute>?, Error?) -> Void) {
        Task {
            let recents = await Store.shared.recents.load()
            let collection = INObjectCollection(items: recents.map(\.route).map(\.intent))
            completion(collection, nil)
        }
    }
    
    private func provideRouteOptionsCollection(with completion: @escaping (INObjectCollection<INRoute>?, Error?) -> Void) {
        Task {
            do {
                let collection = try await routeCollection()
                completion(collection, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    private func routeCollection() async throws -> INObjectCollection<INRoute>? {
        let loader = await RoutesLoader()
        guard let companyRoutes = await loader.load() else {
            if let error = await loader.error {
                throw error
            }
            return nil
        }
        
        var sections = [INObjectSection<INRoute>]()
        for company in companyRoutes where company.company.supportsETA {
            let routes = company.routes.map(\.intent)
            let section = INObjectSection(title: company.company.name, items: routes)
            sections.append(section)
        }
        
        return INObjectCollection(sections: sections)
    }
    
    func resolveRoute(for intent: GetUpcomingBusesIntent, with completion: @escaping (INRouteResolutionResult) -> Void) {
        guard let route = intent.route else {
            completion(.needsValue())
            return
        }
        
        completion(.success(with: route))
    }
    
    // MARK: - Stop
    
    func provideStopOptionsCollection(for intent: GetUpcomingBusesIntent, with completion: @escaping (INObjectCollection<INStop>?, Error?) -> Void) {
        guard let inRoute = intent.route, let route = Route.from(inRoute) else { return }
        Task {
            do {
                let collection = try await stopCollection(for: route)
                completion(collection, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    private func stopCollection(for route: Route) async throws -> INObjectCollection<INStop>? {
        let loader = await RouteStopsLoader()
        guard let stops = await loader.load(key: route) else {
            if let error = await loader.error {
                throw error
            }
            return nil
        }
        
        return INObjectCollection(items: stops.map(\.intent))
    }
    
    func resolveStop(for intent: GetUpcomingBusesIntent, with completion: @escaping (INStopResolutionResult) -> Void) {
        guard let stop = intent.stop else {
            completion(.needsValue())
            return
        }
        
        completion(.success(with: stop))
    }
    
    // MARK: - Handle
    
    func handle(intent: GetUpcomingBusesIntent, completion: @escaping (GetUpcomingBusesIntentResponse) -> Void) {
        guard let inRoute = intent.route,
              let route = Route.from(inRoute),
              let inStop = intent.stop,
              let stop = Stop.from(inStop)
        else {
            completion(.init(code: .missingInfo, userActivity: nil))
            return
        }
        
        let userActivity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
        userActivity.webpageURL = Experience.status(company: route.company, routeID: route.id, stopID: stop.id).toURL()
        
        let response = GetUpcomingBusesIntentResponse(code: .success, userActivity: userActivity)
        response.route = inRoute
        response.stop = inStop
        
        let failure = GetUpcomingBusesIntentResponse(code: .failure, userActivity: userActivity)
        
        Task {
            do {
                let etas = try await etas(for: route, from: stop)
                guard let etas = etas, !etas.isEmpty else {
                    completion(failure)
                    return
                }
                
                response.etas = etas.map(\.intent)
                
                if let next = etas.first?.date {
                    response.nextArrivalTime = self.formatter.string(for: next)
                }
                
                completion(response)
            } catch {
                completion(failure)
            }
        }
    }
    
    private func etas(for route: Route, from stop: Stop) async throws -> [ETA]? {
        let routeStop = RouteStop(route: route, stop: stop)
        let loader = await ETALoader()
        guard let etas = await loader.load(key: routeStop) else {
            if let error = await loader.error {
                throw error
            }
            return nil
        }
        
        return etas
    }
}
