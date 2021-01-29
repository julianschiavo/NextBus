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
    
    private let store = Store()
    private var routesLoader = RoutesLoader()
    private var stopsLoader = RouteStopsLoader()
    private var etaLoader = ETALoader()
    
    private let formatter = RelativeDateTimeFormatter()
    
    override init() {
        super.init()
        formatter.formattingContext = .middleOfSentence
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func resolveSource(for intent: GetUpcomingBusesIntent, with completion: @escaping (INSourceResolutionResult) -> Void) {
        guard intent.source != .unknown else {
            completion(.confirmationRequired(with: .favorites))
            return
        }
        
        completion(.success(with: intent.source))
    }
    
    func provideRouteOptionsCollection(for intent: GetUpcomingBusesIntent, with completion: @escaping (INObjectCollection<INRoute>?, Error?) -> Void) {
        switch intent.source {
        case .favorites:
            DispatchQueue.global(qos: .userInteractive).async {
                let favorites = self.store.favorites.load()
                completion(INObjectCollection(items: favorites.map(\.route).map(\.intent)), nil)
            }
        case .recents:
            DispatchQueue.global(qos: .userInteractive).async {
                let recents = self.store.recents.load()
                completion(INObjectCollection(items: recents.map(\.route).map(\.intent)), nil)
            }
        default:
            routesLoader = RoutesLoader()
            routesLoader.getCachedData(key: .all) { [weak self] cached in
                guard let self = self else { return }
                if let cached = cached {
                    self.sendRouteOptionsCollection(cached, completion: completion)
                } else {
                    self.routesLoader.createPublisher(key: .all)?
                        .sink { loaderCompletion in
                            switch loaderCompletion {
                            case let .failure(error):
                                completion(nil, error)
                            default: return
                            }
                        } receiveValue: { companyRoutes in
                            self.sendRouteOptionsCollection(companyRoutes, completion: completion)
                        }
                        .store(in: &self.cancellables)
                }
            }
        }
    }
    
    func sendRouteOptionsCollection(_ companyRoutes: [CompanyRoutes], completion: @escaping (INObjectCollection<INRoute>?, Error?) -> Void) {
        var sections = [INObjectSection<INRoute>]()
        for company in companyRoutes where company.company.supportsETA {
            let routes = company.routes.map(\.intent)
            let section = INObjectSection(title: company.company.name, items: routes)
            sections.append(section)
        }
        let collection = INObjectCollection(sections: sections)
        completion(collection, nil)
    }
    
    func resolveRoute(for intent: GetUpcomingBusesIntent, with completion: @escaping (INRouteResolutionResult) -> Void) {
        guard let route = intent.route else {
            completion(.needsValue())
            return
        }
        
        completion(.success(with: route))
    }
    
    func provideStopOptionsCollection(for intent: GetUpcomingBusesIntent, with completion: @escaping (INObjectCollection<INStop>?, Error?) -> Void) {
        guard let inRoute = intent.route, let route = Route.from(inRoute) else { return }
        stopsLoader = RouteStopsLoader()
        stopsLoader.getCachedData(key: route) { [weak self] cached in
            guard let self = self else { return }
            if let cached = cached {
                let collection = INObjectCollection(items: cached.map(\.intent))
                completion(collection, nil)
            } else {
                self.stopsLoader.createPublisher(key: route)?
                    .sink { loaderCompletion in
                        switch loaderCompletion {
                        case let .failure(error):
                            completion(nil, error)
                        default: return
                        }
                    } receiveValue: { stops in
                        let collection = INObjectCollection(items: stops.map(\.intent))
                        completion(collection, nil)
                    }
                    .store(in: &self.cancellables)
            }
        }
    }
    
    func resolveStop(for intent: GetUpcomingBusesIntent, with completion: @escaping (INStopResolutionResult) -> Void) {
        guard let stop = intent.stop else {
            completion(.needsValue())
            return
        }
        
        completion(.success(with: stop))
    }
    
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
        userActivity.webpageURL = StatusExperience(company: route.company, routeID: route.id, stopID: stop.id).toURL()
        
        let response = GetUpcomingBusesIntentResponse(code: .success, userActivity: userActivity)
        let failure = GetUpcomingBusesIntentResponse(code: .failure, userActivity: userActivity)
        
        let routeStop = RouteStop(route: route, stop: stop)
        etaLoader = ETALoader()
        etaLoader.createPublisher(key: routeStop)?
//            .first()
            .sink { publisherCompletion in
                switch publisherCompletion {
                case .failure:
                    completion(failure)
                default: return
                }
            } receiveValue: { etas in
                guard !etas.isEmpty else {
                    completion(failure)
                    return
                }
                response.route = inRoute
                response.stop = inStop
                response.etas = etas.map(\.intent)
                if let next = etas.first?.date {
                    response.nextArrivalTime = self.formatter.string(for: next)
                }
                completion(response)
            }
            .store(in: &cancellables)
    }
}
