//
//  ETALoader.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation
import Loadability

class ETALoaderVariant {
    required init(key: ETARequest) { }
    func createRequest() -> URLRequest { URLRequest(url: URL(fileURLWithPath: "")) }
    func decode(_ data: Data) throws -> [ETA] { [] }
}

@MainActor
protocol ETASpecificLoader {
    init(key: RouteStop)
    func load() async throws -> [ETA]
}

class ETALoader: Loader {
    typealias Key = RouteStop
    typealias SpecificLoader = ETASpecificLoader
    
    @Published var object: [ETA]?
    @Published var error: Error?
    
    var cancellable: AnyCancellable?
    var task: Task<[ETA], Error>?
    
    private var loader: SpecificLoader?
    
    required init() {
        
    }
    
    func refresh(key: Key) async {
        await load(key: key)
    }
    
    private func createVariantIfNeeded(for routeStop: RouteStop) {
        guard loader == nil else { return }
        switch routeStop.route.company {
        case .ctb, .nwfb:
            loader = CTBNWFB.ETALoader(key: routeStop)
        case .gmb:
            loader = GMB.ETALoader(key: routeStop)
        case .kmb, .kmbCTB, .kmbNWFB, .lwb, .lwbCTB:
            loader = KMB.ETALoader(key: routeStop)
        case .nlb:
            loader = NLB.ETALoader(key: routeStop)
        default:
            return
        }
    }
    
    func loadData(key routeStop: RouteStop) async throws -> [ETA] {
        createVariantIfNeeded(for: routeStop)
        return try await loader?.load() ?? []
    }
}
