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

class StopsLoader: CachedNetworkLoader {
    typealias Key = Route
    
    private let baseURL = URL(string: "https://nextbus.julian.workers.dev")!
    private let urlMethod = "stops"
    
    @Published var object: [Stop]?
    @Published var error: IdentifiableError?
    
    var cache = StopsCache.self
    var cancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    required init() {
        
    }
    
    deinit {
        cancel()
    }
    
    func createRequest(for request: Route) -> URLRequest {
        fatalError("Not Supported")
    }
    
    func decode(_ data: Data, key request: Route) throws -> [Stop] {
        fatalError("Not Supported")
    }
    
    func loadData(key route: Route) {
        switch route.companyID {
        case .ctb, .nwfb:
            loadNWFBCTBData(route: route)
        case .nlb:
            loadNLBData(route: route)
        default:
            loadData(route: route)
        }
    }
    
    func loadData(route: Route) {
        let urlRequest = createRequest(route: route)
        
        cancellable = URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .retry(3)
            .tryMap { data, response in
                try self.decode(data)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.catchCompletionError(completion)
            } receiveValue: { [weak self] object in
                self?.object = object
            }
    }
    
    func createRequest(route: Route) -> URLRequest {
        let url = baseURL
            .appendingPathComponent(route.category.urlKey)
            .appendingPathComponent(urlMethod)
            .appendingPathComponent(route.id)
        return URLRequest(url: url)
    }
    
    func decode(_ data: Data) throws -> [Stop] {
        let decoder = JSONDecoder()
        let rawStops = try decoder.decode([RawStop].self, from: data)
        return rawStops.map { Stop.from($0) }.sorted { $0.index > $1.index }
    }
    
    func loadNWFBCTBData(route: Route) {
        let urlRequest = createNWFBCTBUnknownRequest(for: route)
        
        cancellable = URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .retry(3)
            .tryMap { data, response in
                try self.decodeNWFBCTBUnknown(data)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.catchCompletionError(completion)
            } receiveValue: { [weak self] object in
                self?.loadNWFBCTBStops(unknownStops: object)
            }
    }
    
    private func loadNWFBCTBStops(unknownStops: [NWFBCTBModels.UnknownStop]) {
        let stopPublishers: [AnyPublisher<Stop, Error>] = unknownStops.map {
            let request = createNWFBCTBRequest(for: $0)
            return URLSession.shared
                .dataTaskPublisher(for: request)
                .retry(3)
                .tryMap { data, response in
                    try self.decodeNWFBCTB(data)
                }
                .eraseToAnyPublisher()
        }
        Publishers.Sequence(sequence: stopPublishers)
            .flatMap { $0 }
            .collect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.catchCompletionError(completion)
            } receiveValue: { [weak self] object in
                self?.object = object
            }
            .store(in: &cancellables)
    }
    
    private func createNWFBCTBUnknownRequest(for route: Route) -> URLRequest {
        let direction = NWFBCTBModels._Direction.from(route.direction)
        
        let url = NWFBCTBModels.baseURL
            .appendingPathComponent("route-stop")
            .appendingPathComponent(route.companyID.rawValue)
            .appendingPathComponent(route.localizedName)
            .appendingPathComponent(direction.parameter)
        
        return URLRequest(url: url)
    }
    
    func decodeNWFBCTBUnknown(_ data: Data) throws -> [NWFBCTBModels.UnknownStop] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let rawUnknownStop = try decoder.decode(NWFBCTBModels.RawUnknownStop.self, from: data)
        return rawUnknownStop.unknownStops
    }
    
    private func createNWFBCTBRequest(for unknownStop: NWFBCTBModels.UnknownStop) -> URLRequest {
        let url = NWFBCTBModels.baseURL
            .appendingPathComponent("stop")
            .appendingPathComponent(unknownStop.id)
        return URLRequest(url: url)
    }
    
    func decodeNWFBCTB(_ data: Data) throws -> Stop {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let rawStop = try decoder.decode(NWFBCTBModels.RawStop.self, from: data)
        return rawStop.toModel()
    }
    
    func loadNLBData(route: Route) {
        let urlRequest = createNLBRequest(for: route)
        
        cancellable = URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .retry(3)
            .tryMap { data, response in
                try self.decodeNLB(data)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.catchCompletionError(completion)
            } receiveValue: { [weak self] object in
                self?.object = object
            }
    }
    
    private func createNLBRequest(for route: Route) -> URLRequest {
        let baseURL = NLBModels.baseURL.appendingPathComponent("stop.php")
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "action", value: "list")]
        
        guard let url = components?.url else { fatalError("Invalid URLComponents Object") }
        
        let requestData = NLBModels.StopRequest(routeId: String(route.id))
        return .postRequest(url: url, body: requestData)
    }
    
    func decodeNLB(_ data: Data) throws -> [Stop] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.dateSpaceTime)
        
        let rawStop = try decoder.decode(NLBModels.RawStop.self, from: data)
        return rawStop.stops
    }
    
    func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }
}
