//
//  RoutesLoader.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

class RoutesCache: SharedCache {
    static let shared = Cache<SimpleKey, [CompanyRoutes]>()
}

protocol RoutesLoaderVariant {
    init(category: Category)
    func createPublisher() -> AnyPublisher<[Route], Error>
}

class RoutesLoader: CachedNetworkLoader {
    
    private let baseURL = URL(string: "https://nextbusapi.schiavo.me")!
    private let urlMethod = "routes"
    
    typealias Key = SimpleKey
    
    @Published var object: [CompanyRoutes]?
    @Published var routes: [Route]?
    @Published var error: IdentifiableError?
    
    var cache = RoutesCache.self
    var cancellable: AnyCancellable?
    
    private let ctbNWFBLoader = CTBNWFB.RoutesLoader(category: .bus)
    private let gmbLoader = GMB.RoutesLoader(category: .minibus)
    private let nlbLoader = NLB.RoutesLoader(category: .bus)
    private let busLoader = GOV.RoutesLoader(category: .bus)
    private let minibusLoader = GOV.RoutesLoader(category: .minibus)
    
    required init() {
        
    }
    
    deinit {
        cancel()
    }
    
    func loadData(key: SimpleKey) {
        let publishers = [
            ctbNWFBLoader.createPublisher(),
            gmbLoader.createPublisher(),
            nlbLoader.createPublisher(),
            busLoader.createPublisher(),
            minibusLoader.createPublisher()
        ]
        
        cancellable = Publishers.Sequence(sequence: publishers)
            .flatMap { $0 }
            .collect()
            .map { [weak self] nested -> [CompanyRoutes] in
                let routes = nested
                    .flatMap { $0 }
                    .sorted { $0.localizedName < $1.localizedName }
                DispatchQueue.main.async {
                    self?.routes = routes
                }
                
                let dictionary = Dictionary(grouping: routes, by: { $0.companyID })
                return dictionary
                    .map { company, routes in
                        CompanyRoutes(company: company, routes: routes)
                    }
                    .sorted {
                        $0.company.name < $1.company.name
                    }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.catchCompletionError(completion)
            } receiveValue: { [weak self] object in
                self?.object = object
                self?.loadCompleted(key: key, object: object)
            }
    }
    
    func createRequest(for key: SimpleKey) -> URLRequest {
        fatalError("Not Supported")
    }
    
    func decode(_ data: Data, key: SimpleKey) throws -> [CompanyRoutes] {
        fatalError("Not Supported")
    }
    
    func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }
}
