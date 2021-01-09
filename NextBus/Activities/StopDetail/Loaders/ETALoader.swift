//
//  ETALoader.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

struct ETARequest: Hashable {
    var route: Route
    var stop: Stop
}

class ETALoader: NetworkLoader {
    typealias Key = ETARequest
    
    @Published var object: [ETA]?
    @Published var error: IdentifiableError?
    
    var cancellable: AnyCancellable?
    
    required init() {
        
    }
    
    deinit {
        cancel()
    }
    
    func createRequest(for request: ETARequest) -> URLRequest {
        switch request.route.companyID {
        case .gmb:
            return createGMBRequest(for: request)
        case .ctb, .nwfb:
            return createNWFBCTBRequest(for: request)
        case .nlb:
            return createNLBRequest(for: request)
        default:
            fatalError()
        }
    }
    
    private func createGMBRequest(for request: ETARequest) -> URLRequest {
        let url = GMBModels.baseURL
            .appendingPathComponent("eta")
            .appendingPathComponent("route-stop")
            .appendingPathComponent(request.route.id)
            .appendingPathComponent(request.route.direction.sequence)
            .appendingPathComponent(request.stop.id)
        return URLRequest(url: url)
    }
    
    private func createNWFBCTBRequest(for request: ETARequest) -> URLRequest {
        let url = NWFBCTBModels.baseURL
            .appendingPathComponent("eta")
            .appendingPathComponent(request.route.companyID.rawValue)
            .appendingPathComponent(request.stop.id)
            .appendingPathComponent(request.route.localizedName)
        return URLRequest(url: url)
    }
    
    private func createNLBRequest(for request: ETARequest) -> URLRequest {
        let baseURL = NLBModels.baseURL.appendingPathComponent("stop.php")
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "action", value: "estimatedArrivals")]
        
        guard let url = components?.url else { fatalError("Invalid URLComponents Object") }
        
        let requestData = NLBModels.ETARequest(routeId: String(request.route.id), stopId: request.stop.id)
        return .postRequest(url: url, body: requestData)
    }
    
    func decode(_ data: Data, key: ETARequest) throws -> [ETA] {
        switch key.route.companyID {
        case .gmb:
            return try decodeGMB(data)
        case .ctb, .nwfb:
            return try decodeNWFBCTB(data, request: key)
        case .nlb:
            return try decodeNLB(data, request: key)
        default:
            fatalError()
        }
    }
    
    func decodeGMB(_ data: Data) throws -> [ETA] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let rawETA = try decoder.decode(GMBModels.RawETA.self, from: data)
        return rawETA.etas
    }
    
    func decodeNWFBCTB(_ data: Data, request: ETARequest) throws -> [ETA] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let rawETA = try decoder.decode(NWFBCTBModels.RawETA.self, from: data)
        let etas = rawETA.etas(for: request.route.direction)
        return Array(etas)
    }
    
    func decodeNLB(_ data: Data, request: ETARequest) throws -> [ETA] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.dateSpaceTime)
        
        let rawETA = try decoder.decode(NLBModels.RawETA.self, from: data)
        let etas = rawETA.etas(for: request.route)
        return Array(etas)
    }
    
    func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }
}
