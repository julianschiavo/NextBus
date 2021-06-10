//
//  SelectRouteStopIntentHandler.swift
//  IntentsExtension
//
//  Created by Julian Schiavo on 13/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Intents

class SelectRouteStopIntentHandler: NSObject, SelectRouteStopIntentHandling {
    
    private let store = Store()
    private var routesLoader = RoutesLoader()
    private var stopsLoader = RouteStopsLoader()
    
    private var cancellables = Set<AnyCancellable>()
    
    func resolveWidgetStyle(for intent: SelectRouteStopIntent, with completion: @escaping (INWidgetStyleResolutionResult) -> Void) {
        guard intent.widgetStyle != .unknown else {
            completion(.confirmationRequired(with: .whiteBlack))
            return
        }
        
        completion(.success(with: intent.widgetStyle))
    }
    
    func resolveSource(for intent: SelectRouteStopIntent, with completion: @escaping (INSourceResolutionResult) -> Void) {
        guard intent.source != .unknown else {
            completion(.confirmationRequired(with: .favorites))
            return
        }
        
        completion(.success(with: intent.source))
    }
    
    func provideFavoritesOptionsCollection(for intent: SelectRouteStopIntent, with completion: @escaping (INObjectCollection<INRouteStop>?, Error?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let favorites = self.store.favorites.load()
            completion(INObjectCollection(items: favorites.map(\.intent)), nil)
        }
    }
    
    func resolveFavorites(for intent: SelectRouteStopIntent, with completion: @escaping ([INRouteStopResolutionResult]) -> Void) {
        guard let favorites = intent.favorites else {
            completion([])
            return
        }
        
        completion(favorites.map { .success(with: $0) })
    }
    
    func provideFirstRouteOptionsCollection(for intent: SelectRouteStopIntent, with completion: @escaping (INObjectCollection<INRoute>?, Error?) -> Void) {
        prepareRouteCollection(completion: completion)
    }
    
    func provideSecondRouteOptionsCollection(for intent: SelectRouteStopIntent, with completion: @escaping (INObjectCollection<INRoute>?, Error?) -> Void) {
        prepareRouteCollection(completion: completion)
    }
    
    func provideThirdRouteOptionsCollection(for intent: SelectRouteStopIntent, with completion: @escaping (INObjectCollection<INRoute>?, Error?) -> Void) {
        prepareRouteCollection(completion: completion)
    }
    
    func provideFourthRouteOptionsCollection(for intent: SelectRouteStopIntent, with completion: @escaping (INObjectCollection<INRoute>?, Error?) -> Void) {
        prepareRouteCollection(completion: completion)
    }
    
    func resolveFirstRoute(for intent: SelectRouteStopIntent, with completion: @escaping (INRouteResolutionResult) -> Void) {
        resolveRoute(intent.firstRoute, with: completion)
    }
    
    func resolveSecondRoute(for intent: SelectRouteStopIntent, with completion: @escaping (INRouteResolutionResult) -> Void) {
        resolveRoute(intent.secondRoute, with: completion)
    }
    
    func resolveThirdRoute(for intent: SelectRouteStopIntent, with completion: @escaping (INRouteResolutionResult) -> Void) {
        resolveRoute(intent.thirdRoute, with: completion)
    }
    
    func resolveFourthRoute(for intent: SelectRouteStopIntent, with completion: @escaping (INRouteResolutionResult) -> Void) {
        resolveRoute(intent.fourthRoute, with: completion)
    }
    
    func provideFirstStopOptionsCollection(for intent: SelectRouteStopIntent, with completion: @escaping (INObjectCollection<INStop>?, Error?) -> Void) {
        guard let inRoute = intent.firstRoute, let route = Route.from(inRoute) else { return }
        prepareStopCollection(for: route, with: completion)
    }
    
    func provideSecondStopOptionsCollection(for intent: SelectRouteStopIntent, with completion: @escaping (INObjectCollection<INStop>?, Error?) -> Void) {
        guard let inRoute = intent.secondRoute, let route = Route.from(inRoute) else { return }
        prepareStopCollection(for: route, with: completion)
    }
    
    func provideThirdStopOptionsCollection(for intent: SelectRouteStopIntent, with completion: @escaping (INObjectCollection<INStop>?, Error?) -> Void) {
        guard let inRoute = intent.thirdRoute, let route = Route.from(inRoute) else { return }
        prepareStopCollection(for: route, with: completion)
    }
    
    func provideFourthStopOptionsCollection(for intent: SelectRouteStopIntent, with completion: @escaping (INObjectCollection<INStop>?, Error?) -> Void) {
        guard let inRoute = intent.fourthRoute, let route = Route.from(inRoute) else { return }
        prepareStopCollection(for: route, with: completion)
    }
    
    func resolveFirstStop(for intent: SelectRouteStopIntent, with completion: @escaping (INStopResolutionResult) -> Void) {
        resolveStop(intent.firstStop, with: completion)
    }
    
    func resolveSecondStop(for intent: SelectRouteStopIntent, with completion: @escaping (INStopResolutionResult) -> Void) {
        resolveStop(intent.secondStop, with: completion)
    }
    
    func resolveThirdStop(for intent: SelectRouteStopIntent, with completion: @escaping (INStopResolutionResult) -> Void) {
        resolveStop(intent.thirdStop, with: completion)
    }
    
    func resolveFourthStop(for intent: SelectRouteStopIntent, with completion: @escaping (INStopResolutionResult) -> Void) {
        resolveStop(intent.fourthStop, with: completion)
    }
    
    // MARK: - Private
    
    private func prepareRouteCollection(completion: @escaping (INObjectCollection<INRoute>?, Error?) -> Void) {
        routesLoader = RoutesLoader()
        routesLoader.getCachedData(key: .key) { cached in
            if let cached = cached {
                self.sendRouteOptionsCollection(cached, completion: completion)
            } else {
                self.routesLoader.createPublisher(key: .key)?
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
    
    private func resolveRoute(_ route: INRoute?, with completion: @escaping (INRouteResolutionResult) -> Void) {
        guard let route = route else {
            completion(.needsValue())
            return
        }
        
        completion(.success(with: route))
    }
    
    private func prepareStopCollection(for route: Route, with completion: @escaping (INObjectCollection<INStop>?, Error?) -> Void) {
        stopsLoader = RouteStopsLoader()
        stopsLoader.getCachedData(key: route) { cached in
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
    
    private func resolveStop(_ stop: INStop?, with completion: @escaping (INStopResolutionResult) -> Void) {
        guard let stop = stop else {
            completion(.needsValue())
            return
        }
        
        completion(.success(with: stop))
    }
}
