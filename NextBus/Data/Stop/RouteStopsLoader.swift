//
//  RouteStopsLoader.swift
//  NextBus
//
//  Created by Julian Schiavo on 6/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation
import Loadability

class StopsCache: SharedSerializableCache {
    typealias Key = Route
    typealias Value = [Stop]
    static let shared = SerializableCache<Route, [Stop]>.load(name: "RouteStops", folderURL: Store.appGroupFolderURL)
}

protocol RouteStopsPublisherBuilder {
    init(key: Route)
    func create() -> AnyPublisher<[Stop], Error>
}

class RouteStopsLoader: CachedLoader {
    typealias Key = Route
    typealias PublisherBuilder = RouteStopsPublisherBuilder
    
    @Published var object: [Stop]?
    @Published var error: IdentifiableError?
    
    var cache = StopsCache.self
    var cancellable: AnyCancellable?

    private var builder: RouteStopsPublisherBuilder?
    private var currentRoute: Route?
    
    required init() {
        
    }
    
    private func createVariantIfNeeded(route: Route) {
        guard builder == nil || currentRoute != route else { return }
        
        let builderType: RouteStopsPublisherBuilder.Type
        switch route.company {
        case .gmb:
            builderType = GMB.RouteStopsPublisherBuilder.self
        case .ctb, .nwfb:
            builderType = CTBNWFB.RouteStopsPublisherBuilder.self
        case .nlb:
            builderType = NLB.RouteStopsPublisherBuilder.self
        default:
            builderType = GOV.RouteStopsPublisherBuilder.self
        }
        
        builder = builderType.init(key: route)
        currentRoute = route
    }
    
    func createPublisher(key route: Route) -> AnyPublisher<[Stop], Error>? {
        createVariantIfNeeded(route: route)
        return builder?.create()
    }
}
