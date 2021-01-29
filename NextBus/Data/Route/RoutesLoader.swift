//
//  RoutesLoader.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

class RoutesCache: SerializableSingularCache {
    typealias Key = SimpleKey
    typealias Value = [CompanyRoutes]
    static let shared = SerializableCache<SimpleKey, [CompanyRoutes]>.load(name: "Routes")
}

class RoutesLoader: CachedLoader {
    
    private let baseURL = URL(string: "https://nextbusapi.schiavo.me")!
    private let urlMethod = "routes"
    
    typealias Key = SimpleKey
    
    @Published var object: [CompanyRoutes]?
    @Published var routes: [Route]?
    @Published var error: IdentifiableError?
    
    var cache = RoutesCache.self
    var cancellable: AnyCancellable?
    
    private let ctbNWFBBuilder = CTBNWFB.RoutesPublisherBuilder(key: .bus)
    private let gmbBuilder = GMB.RoutesPublisherBuilder(key: .minibus)
    private let nlbBuilder = NLB.RoutesPublisherBuilder(key: .bus)
    private let busBuilder = GOV.RoutesPublisherBuilder(key: .bus)
    private let minibusBuilder = GOV.RoutesPublisherBuilder(key: .minibus)
    
    required init() {
        
    }
    
    deinit {
        cancel()
    }
    
    func createPublisher(key: SimpleKey) -> AnyPublisher<[CompanyRoutes], Error>? {
        let publishers = [
            ctbNWFBBuilder.create(),
            gmbBuilder.create(),
            nlbBuilder.create(),
            busBuilder.create(),
            minibusBuilder.create()
        ]
        
        return Publishers.MergeMany(publishers)
            .collect()
            .map { [weak self] nested -> [CompanyRoutes] in
                let routes = nested
                    .flatMap { $0 }
                    .sorted { $0.localizedName < $1.localizedName }
                    .removingDuplicates()
                DispatchQueue.main.async {
                    self?.routes = routes
                }
                SpotlightBuddy.shared.index(routes: routes)
                
                let dictionary = Dictionary(grouping: routes, by: { $0.company })
                return dictionary
                    .map { company, routes in
                        CompanyRoutes(company: company, routes: routes)
                    }
                    .sorted {
                        $0.company.name < $1.company.name
                    }
            }
            .eraseToAnyPublisher()
    }
}
