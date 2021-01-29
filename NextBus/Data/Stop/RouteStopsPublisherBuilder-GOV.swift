//
//  RouteStopsPublisherBuilder-GOV.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

extension GOV {
    class RouteStopsPublisherBuilder: PublisherBuilder, RouteStopsLoader.PublisherBuilder {
        private let route: Route
        
        private let urlMethod = "stops"
        
        required init(key route: Route) {
            self.route = route
        }
        
        func create() -> AnyPublisher<[Stop], Error> {
            let urlRequest = createRequest()
            
            return URLSession.shared
                .dataTaskPublisher(for: urlRequest)
                .retry(3)
                .tryMap { data, response in
                    try self.decode(data)
                }
                .eraseToAnyPublisher()
        }
        
        private func createRequest() -> URLRequest {
            let url = baseURL
                .appendingPathComponent(route.category.urlKey)
                .appendingPathComponent(urlMethod)
                .appendingPathComponent(route._id)
            return URLRequest(url: url)
        }
        
        private func decode(_ data: Data) throws -> [Stop] {
            let decoder = JSONDecoder()
            let rawStops = try decoder.decode([RawStop].self, from: data)
            return rawStops
                .filter { Direction.fromGovSequence($0.direction) == route.direction }
                .map { $0.stop }
                .sorted { $0.index < $1.index }
        }
    }
}
