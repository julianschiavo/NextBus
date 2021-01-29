//
//  RouteStopsPublisherBuilder-CTBNWFB.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

extension CTBNWFB {
    class RouteStopsPublisherBuilder: PublisherBuilder, RouteStopsLoader.PublisherBuilder {
        private let route: Route
        
        required init(key route: Route) {
            self.route = route
        }
        
        func create() -> AnyPublisher<[Stop], Error> {
            let urlRequest = createUnknownRequest()
            
            return URLSession.shared
                .dataTaskPublisher(for: urlRequest)
                .retry(3)
                .tryMap { data, response in
                    try self.decodeUnknown(data)
                }
                .flatMap(createStopsPublisher)
                .eraseToAnyPublisher()
        }
        
        private func createUnknownRequest() -> URLRequest {
            let direction = _Direction.from(route.direction)
            let url = baseURL
                .appendingPathComponent("route-stop")
                .appendingPathComponent(route.company.rawValue)
                .appendingPathComponent(route.localizedName)
                .appendingPathComponent(direction.parameter)
            return URLRequest(url: url)
        }
        
        private func decodeUnknown(_ data: Data) throws -> [UnknownStop] {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let rawUnknownStop = try decoder.decode(RawUnknownStop.self, from: data)
            return rawUnknownStop.unknownStops
        }
        
        private func createStopsPublisher(unknownStops: [UnknownStop]) -> AnyPublisher<[Stop], Error> {
            let idOrder = unknownStops.map(\.id)
            let publishers = unknownStops.map(createPublisher)
            
            return Publishers.MergeMany(publishers)
                .collect()
                .map { stops in
                    stops.reorder(using: idOrder)
                }
                .map { stops in
                    var stops = stops
                    for i in 0..<stops.count {
                        stops[i].index = unknownStops[i].index
                    }
                    return stops
                }
                .eraseToAnyPublisher()
        }
        
        private func createPublisher(for unknownStop: UnknownStop) -> AnyPublisher<Stop, Error> {
            let request = createRequest(for: unknownStop)
            return URLSession.shared
                .dataTaskPublisher(for: request)
                .retry(3)
                .tryMap { data, response in
                    try self.decode(data)
                }
                .eraseToAnyPublisher()
        }
        
        private func createRequest(for unknownStop: UnknownStop) -> URLRequest {
            let url = baseURL
                .appendingPathComponent("stop")
                .appendingPathComponent(unknownStop.id)
            return URLRequest(url: url)
        }
        
        func decode(_ data: Data) throws -> Stop {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let rawStop = try decoder.decode(RawStop.self, from: data)
            return rawStop.stop
        }
    }
}
