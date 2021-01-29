//
//  ETAPublisherBuilder-CTBNWFB.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

extension CTBNWFB {
    class ETAPublisherBuilder: PublisherBuilder, ETALoader.PublisherBuilder {
        private let route: Route
        private let stop: Stop
        
        required init(key routeStop: RouteStop) {
            self.route = routeStop.route
            self.stop = routeStop.stop
        }
        
        func create() -> AnyPublisher<[ETA], Error> {
            let request = createRequest()
            return URLSession.shared
                .dataTaskPublisher(for: request)
                .retry(3)
                .tryMap { data, response in
                    try self.decode(data)
                }
                .eraseToAnyPublisher()
        }
        
        private func createRequest() -> URLRequest {
            let url = baseURL
                .appendingPathComponent("eta")
                .appendingPathComponent(route.company.rawValue)
                .appendingPathComponent(stop.id)
                .appendingPathComponent(route.localizedName)
            return URLRequest(url: url)
        }
        
        private func decode(_ data: Data) throws -> [ETA] {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let rawETA = try decoder.decode(RawETA.self, from: data)
            return rawETA.etas(for: route.direction)
        }
    }
}
