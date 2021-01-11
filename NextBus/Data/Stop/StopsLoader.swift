//
//  StopsLoader.swift
//  NextBus
//
//  Created by Julian Schiavo on 6/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

class StopsCache: SharedCache {
    static let shared = Cache<Route, [Stop]>()
}

class StopsLoaderVariant: LoaderVariant {
    @Published var object: [Stop]?
    @Published var error: IdentifiableError?
    required init(key: Route) { }
    func load() { }
    func cancel() { }
}

class StopsLoader: CachedNetworkLoader {
    typealias Key = Route
    
    @Published var object: [Stop]?
    @Published var error: IdentifiableError?
    
    var cache = StopsCache.self
    var cancellable: AnyCancellable?

    private var cancellables = Set<AnyCancellable>()
    private var variant: StopsLoaderVariant?
    
    required init() {
        
    }
    
    deinit {
        cancel()
    }
    
    private func createVariantIfNeeded(route: Route) {
        guard variant == nil else { return }
        
        let loaderType: StopsLoaderVariant.Type
        switch route.companyID {
        case .gmb:
            loaderType = GMB.StopsLoader.self
        case .ctb, .nwfb:
            loaderType = CTBNWFB.StopsLoader.self
        case .nlb:
            loaderType = NLB.StopsLoader.self
        default:
            loaderType = GOV.StopsLoader.self
        }
        
        variant = loaderType.init(key: route)
    }
    
    func loadData(key route: Route) {
        createVariantIfNeeded(route: route)
        
        variant?.$object
            .sink { [weak self] object in
                self?.object = object
                if let object = object {
                    self?.loadCompleted(key: route, object: object)
                }
            }
            .store(in: &cancellables)
        variant?.$error
            .assign(to: \.error, on: self)
            .store(in: &cancellables)
        variant?.load()
    }
    
    func createRequest(for request: Route) -> URLRequest {
        fatalError("Not Supported")
    }
    
    func decode(_ data: Data, key request: Route) throws -> [Stop] {
        fatalError("Not Supported")
    }
    
    func cancel() {
        cancellable?.cancel()
        cancellable = nil
        variant?.cancel()
    }
}
