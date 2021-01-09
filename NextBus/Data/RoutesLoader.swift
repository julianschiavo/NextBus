//
//  RoutesLoader.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

class RoutesLoader: NetworkLoader {
    
    private let baseURL = URL(string: "https://nextbus.julian.workers.dev")!
    private let urlMethod = "routes"
    
    typealias Key = SimpleKey
    
    @Published var object: [CompanyRoutes]?
    @Published var routes: [Route]?
    @Published var error: IdentifiableError?
    
//    var cache = RoutesCache.self
    var cancellable: AnyCancellable?
    
    required init() {
        
    }
    
    deinit {
        cancel()
    }
    
    func loadData(key: SimpleKey) {
        var publishers = Category.allCases.map {
            createPublisher(category: $0)
        }
        publishers.append(createCTBPublisher())
        publishers.append(createNLBPublisher())
        publishers.append(createNWFBPublisher())
        
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
            }
    }
    
    func createRequest(for key: SimpleKey) -> URLRequest {
        fatalError("Not Supported")
    }
    
    func decode(_ data: Data, key: SimpleKey) throws -> [CompanyRoutes] {
        fatalError("Not Supported")
    }
    
    private func createPublisher(category: Category) -> AnyPublisher<[Route], Error> {
        let request = createRequest(category: category)
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .retry(3)
            .tryMap { data, response in
                try self.decode(data)
            }
            .map { routes in
                routes.filter { ![CompanyID.ctb, .nlb, .nwfb].contains($0.companyID) }
            }
            .eraseToAnyPublisher()
    }
    
    private func createCTBPublisher() -> AnyPublisher<[Route], Error> {
        let request = createCTBRequest()
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .retry(3)
            .tryMap { data, response in
                try self.decodeCTBNWFB(data)
            }
            .eraseToAnyPublisher()
    }
    
    private func createNLBPublisher() -> AnyPublisher<[Route], Error> {
        let request = createNLBRequest()
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .retry(3)
            .tryMap { data, response in
                try self.decodeNLB(data)
            }
            .eraseToAnyPublisher()
    }
    
    private func createNWFBPublisher() -> AnyPublisher<[Route], Error> {
        let request = createNWFBRequest()
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .retry(3)
            .tryMap { data, response in
                try self.decodeCTBNWFB(data)
            }
            .eraseToAnyPublisher()
    }
    
    private func createRequest(category: Category) -> URLRequest {
        let url = baseURL
            .appendingPathComponent(category.urlKey)
            .appendingPathComponent(urlMethod)
        return URLRequest(url: url)
    }
    
    private func createCTBRequest() -> URLRequest {
        let url = NWFBCTBModels.baseURL
            .appendingPathComponent("route")
            .appendingPathComponent(CompanyID.ctb.rawValue)
        return URLRequest(url: url)
    }
    
    private func createNLBRequest() -> URLRequest {
        let baseURL = NLBModels.baseURL.appendingPathComponent("route.php")
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "action", value: "list")]
        
        guard let url = components?.url else { fatalError("Invalid URLComponents Object") }
        return URLRequest(url: url)
    }
    
    private func createNWFBRequest() -> URLRequest {
        let url = NWFBCTBModels.baseURL
            .appendingPathComponent("route")
            .appendingPathComponent(CompanyID.nwfb.rawValue)
        return URLRequest(url: url)
    }
    
    private func decode(_ data: Data) throws -> [Route] {
        let decoder = JSONDecoder()
        let rawRoutes = try decoder.decode([RawRoute].self, from: data)
        return rawRoutes.map { Route.from($0) }
    }
    
    private func decodeCTBNWFB(_ data: Data) throws -> [Route] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let rawRoutes = try decoder.decode(NWFBCTBModels.RawRoute.self, from: data)
        let routes = rawRoutes.routes
        return routes.flatMap { route -> [Route] in
            var inbound = route
            inbound.id = inbound.id + Direction.outbound.rawValue
            inbound.direction = .outbound
            let destination = inbound.origin
            inbound.origin = inbound.destination
            inbound.destination = destination
            return [inbound, route]
        }
    }
    
    private func decodeNLB(_ data: Data) throws -> [Route] {
        let decoder = JSONDecoder()
        let rawRoutes = try decoder.decode(NLBModels.RawRoute.self, from: data)
        return rawRoutes.routes
    }
    
    func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }
}
