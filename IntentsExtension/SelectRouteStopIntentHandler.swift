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
        Task {
            let favorites = await Store.shared.favorites.load()
            let collection = INObjectCollection(items: favorites.map(\.intent))
            completion(collection, nil)
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
        provideRouteOptionsCollection(for: intent, with: completion)
    }
    
    func provideSecondRouteOptionsCollection(for intent: SelectRouteStopIntent, with completion: @escaping (INObjectCollection<INRoute>?, Error?) -> Void) {
        provideRouteOptionsCollection(for: intent, with: completion)
    }
    
    func provideThirdRouteOptionsCollection(for intent: SelectRouteStopIntent, with completion: @escaping (INObjectCollection<INRoute>?, Error?) -> Void) {
        provideRouteOptionsCollection(for: intent, with: completion)
    }
    
    func provideFourthRouteOptionsCollection(for intent: SelectRouteStopIntent, with completion: @escaping (INObjectCollection<INRoute>?, Error?) -> Void) {
        provideRouteOptionsCollection(for: intent, with: completion)
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
        provideStopOptionsCollection(for: route, with: completion)
    }
    
    func provideSecondStopOptionsCollection(for intent: SelectRouteStopIntent, with completion: @escaping (INObjectCollection<INStop>?, Error?) -> Void) {
        guard let inRoute = intent.secondRoute, let route = Route.from(inRoute) else { return }
        provideStopOptionsCollection(for: route, with: completion)
    }
    
    func provideThirdStopOptionsCollection(for intent: SelectRouteStopIntent, with completion: @escaping (INObjectCollection<INStop>?, Error?) -> Void) {
        guard let inRoute = intent.thirdRoute, let route = Route.from(inRoute) else { return }
        provideStopOptionsCollection(for: route, with: completion)
    }
    
    func provideFourthStopOptionsCollection(for intent: SelectRouteStopIntent, with completion: @escaping (INObjectCollection<INStop>?, Error?) -> Void) {
        guard let inRoute = intent.fourthRoute, let route = Route.from(inRoute) else { return }
        provideStopOptionsCollection(for: route, with: completion)
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
    
    private func provideRouteOptionsCollection(for intent: SelectRouteStopIntent, with completion: @escaping (INObjectCollection<INRoute>?, Error?) -> Void) {
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
    
    private func resolveRoute(_ route: INRoute?, with completion: @escaping (INRouteResolutionResult) -> Void) {
        guard let route = route else {
            completion(.needsValue())
            return
        }
        
        completion(.success(with: route))
    }
    
    private func provideStopOptionsCollection(for route: Route, with completion: @escaping (INObjectCollection<INStop>?, Error?) -> Void) {
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
    
    private func resolveStop(_ stop: INStop?, with completion: @escaping (INStopResolutionResult) -> Void) {
        guard let stop = stop else {
            completion(.needsValue())
            return
        }
        
        completion(.success(with: stop))
    }
}
