//
//  RoutesLoader.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation
import Loadability

@MainActor class RoutesCache: SharedSerializableCache {
    typealias Key = GenericKey
    typealias Value = [CompanyRoutes]
    static let shared = SerializableCache<GenericKey, [CompanyRoutes]>.load(name: "Routes", folderURL: Store.appGroupFolderURL)
}

class RoutesLoader: CachedLoader {
    private let baseURL = URL(string: "https://nextbusapi.schiavo.me")!
    private let urlMethod = "routes"
    
    typealias Key = GenericKey
    
    @Published var object: [CompanyRoutes]?
    @Published var filteredRoutes = [Company: [Route]]()
    @Published var routes: [Route]?
    @Published var error: Error?
    
    var cache = RoutesCache.self
    var cancellable: AnyCancellable?
    var task: Task<[CompanyRoutes], Error>?
    
    private let ctbNWFBLoader = CTBNWFB.RoutesLoader(key: .bus)
    private let gmbLoader = GMB.RoutesLoader(key: .minibus)
    private let nlbLoader = NLB.RoutesLoader(key: .bus)
    private let busLoader = GOV.RoutesLoader(key: .bus)
    private let minibusLoader = GOV.RoutesLoader(key: .minibus)
    
    required init() {
        
    }
    
    func loadData(key: GenericKey) async throws -> [CompanyRoutes] {
        async let ctbNWFBRoutes = ctbNWFBLoader.load()
        async let gmbRoutes = gmbLoader.load()
        async let nlbRoutes = nlbLoader.load()
        async let busRoutes = busLoader.load()
        async let minibusRoutes = minibusLoader.load()
        let routes = try await ctbNWFBRoutes + gmbRoutes + nlbRoutes + busRoutes + minibusRoutes
        self.routes = routes
        
        Task.detached {
            await SpotlightBuddy.shared.index(routes: routes)
        }
        
        let task = Task { () -> [CompanyRoutes] in
            let dictionary = Dictionary(grouping: routes, by: \.company)
            return dictionary
                .map { company, routes in
                    CompanyRoutes(company: company, routes: routes)
                }
                .sorted {
                    $0.company.name < $1.company.name
                }
        }
        return await task.value
    }
}
