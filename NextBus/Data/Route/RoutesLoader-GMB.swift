//
//  RoutesLoader-GMB.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

extension GMB {
    class RoutesLoader: RoutesLoaderVariant {
        
        required init(category: Category) {
            
        }
        
        func createPublisher() -> AnyPublisher<[Route], Error> {
            let request = createUnknownRequest()
            return URLSession.shared
                .dataTaskPublisher(for: request)
                .retry(3)
                .tryMap { data, response in
                    try self.decodeUnknown(data)
                }
                .flatMap(createSpecificPublisher)
                .eraseToAnyPublisher()
        }
        
        private func createSpecificPublisher(unknownRoutes: [UnknownRoute]) -> AnyPublisher<[Route], Error> {
            
            let publishers: [AnyPublisher<[Route], Error>] = unknownRoutes.map {
                let request = createRequest(route: $0)
                return URLSession.shared
                    .dataTaskPublisher(for: request)
                    .retry(3)
                    .tryMap { data, response in
                        try self.decode(data)
                    }
                    .eraseToAnyPublisher()
            }
            return Publishers.Sequence(sequence: publishers)
                .flatMap { $0 }
                .map { routes in
                    var routes = routes
                    for i in 0..<routes.count {
                        routes[i].name = LocalizedText(unknownRoutes[i].name)
                    }
                    return routes
                }
                .eraseToAnyPublisher()
        }
        
        private func createUnknownRequest() -> URLRequest {
            let url = GMB.baseURL
                .appendingPathComponent("route")
            return URLRequest(url: url)
        }
        
        private func createRequest(route: UnknownRoute) -> URLRequest {
            let url = GMB.baseURL
                .appendingPathComponent("route")
                .appendingPathComponent(route.region.rawValue)
                .appendingPathComponent(route.name)
            return URLRequest(url: url)
        }
        
        private func decodeUnknown(_ data: Data) throws -> [UnknownRoute] {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601FractionalSeconds
            let rawRoutes = try decoder.decode(RawUnknownRoute.self, from: data)
            return rawRoutes.routes
        }
        
        private func decode(_ data: Data) throws -> [Route] {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601FractionalSeconds
            let rawRoutes = try decoder.decode(RawRoute.self, from: data)
            return rawRoutes.routes
        }
    }
}
