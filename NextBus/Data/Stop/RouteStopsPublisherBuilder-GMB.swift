//
//  RouteStopsPublisherBuilder-GMB.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

extension GMB {
    class RouteStopsPublisherBuilder: PublisherBuilder, RouteStopsLoader.PublisherBuilder {
        private let route: Route
        
        required init(key route: Route) {
            self.route = route
        }
        
        func create() -> AnyPublisher<[Stop], Error> {
            let urlRequest = createRequest(for: route)
            return URLSession.shared
                .dataTaskPublisher(for: urlRequest)
                .retry(3)
                .tryMap { data, response in
                    try self.decode(data)
                }
                .eraseToAnyPublisher()
        }
        
        private func createRequest(for route: Route) -> URLRequest {
            let url = baseURL
                .appendingPathComponent("route-stop")
                .appendingPathComponent(route._id)
                .appendingPathComponent(route.direction.sequence)
            return URLRequest(url: url)
        }
        
        private func decode(_ data: Data) throws -> [Stop] {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601FractionalSeconds
            let rawStop = try decoder.decode(RawStop.self, from: data)
            return rawStop.stops
        }
    }
}
