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

@MainActor class StopsCache: SharedSerializableCache {
    typealias Key = Route
    typealias Value = [Stop]
    static let shared = SerializableCache<Route, [Stop]>.load(name: "RouteStops", folderURL: Store.appGroupFolderURL)
}

@MainActor
protocol RouteStopsSpecificLoader {
    init(key: Route)
    func load() async throws -> [Stop]
}

class RouteStopsLoader: CachedLoader {
    typealias Key = Route
    typealias SpecificLoader = RouteStopsSpecificLoader
    
    @Published var object: [Stop]?
    @Published var error: Error?
    
    var cache = StopsCache.self
    var cancellable: AnyCancellable?
    var task: Task<[Stop], Error>?
    
    private var loader: SpecificLoader?
    private var currentRoute: Route?
    
    required init() {
        
    }
    
    private func createVariantIfNeeded(route: Route) {
        guard loader == nil || currentRoute != route else { return }
        
        let loaderType: SpecificLoader.Type
        switch route.company {
        case .gmb:
            loaderType = GMB.RouteStopsLoader.self
        case .ctb, .nwfb:
            loaderType = CTBNWFB.RouteStopsLoader.self
        case .nlb:
            loaderType = NLB.RouteStopsLoader.self
        default:
            loaderType = GOV.RouteStopsLoader.self
        }
        
        loader = loaderType.init(key: route)
        currentRoute = route
    }
    
    func loadData(key route: Route) async throws -> [Stop] {
        createVariantIfNeeded(route: route)
        return try await loader?.load() ?? []
    }
}
