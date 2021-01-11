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

class ETALoader: NetworkLoader {
    typealias Key = ETARequest
    
    @Published var object: [ETA]?
    @Published var error: IdentifiableError?
    
    var cancellable: AnyCancellable?
    
    private var variant: ETALoaderVariant?
    
    required init() {
        
    }
    
    deinit {
        cancel()
    }
    
    private func createVariantIfNeeded(for request: ETARequest) {
        guard variant == nil else { return }
        switch request.route.companyID {
        case .ctb, .nwfb:
            variant = CTBNWFB.ETALoader(key: request)
        case .gmb:
            variant = GMB.ETALoader(key: request)
        case .kmb, .kmbCTB, .kmbNWFB:
            variant = KMB.ETALoader(key: request)
        case .nlb:
            variant = NLB.ETALoader(key: request)
        default:
            return
        }
    }
    
    func createRequest(for request: ETARequest) -> URLRequest {
        createVariantIfNeeded(for: request)
        return variant?.createRequest() ?? URLRequest(url: URL(fileURLWithPath: ""))
    }
    
    func decode(_ data: Data, key: ETARequest) throws -> [ETA] {
        try variant?.decode(data) ?? []
    }
    
    func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }
}
