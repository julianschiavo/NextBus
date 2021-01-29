//
//  ETALoader.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

class ETALoaderVariant {
    required init(key: ETARequest) { }
    func createRequest() -> URLRequest { URLRequest(url: URL(fileURLWithPath: "")) }
    func decode(_ data: Data) throws -> [ETA] { [] }
}

protocol ETAPublisherBuilder {
    init(key: RouteStop)
    func create() -> AnyPublisher<[ETA], Error>
}

class ETALoader: Loader {
    typealias Key = RouteStop
    typealias PublisherBuilder = ETAPublisherBuilder
    
    @Published var object: [ETA]?
    @Published var error: IdentifiableError?
    
    var cancellable: AnyCancellable?
    
    private var builder: ETAPublisherBuilder?
    
    required init() {
        
    }
    
    deinit {
        cancel()
    }
    
    private func createVariantIfNeeded(for routeStop: RouteStop) {
        guard builder == nil else { return }
        switch routeStop.route.company {
        case .ctb, .nwfb:
            builder = CTBNWFB.ETAPublisherBuilder(key: routeStop)
        case .gmb:
            builder = GMB.ETAPublisherBuilder(key: routeStop)
        case .kmb, .kmbCTB, .kmbNWFB, .lwb, .lwbCTB:
            builder = KMB.ETAPublisherBuilder(key: routeStop)
        case .nlb:
            builder = NLB.ETAPublisherBuilder(key: routeStop)
        default:
            return
        }
    }
    
    func createPublisher(key routeStop: RouteStop) -> AnyPublisher<[ETA], Error>? {
        createVariantIfNeeded(for: routeStop)
        return builder?.create()
    }
}
