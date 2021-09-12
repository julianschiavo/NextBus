//
//  RouteStopsLoader-GMB.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

extension GMB {
    class RouteStopsLoader: SpecificLoader, RouteStopsSpecificLoader {
        private let route: Route
        
        required init(key route: Route) {
            self.route = route
        }
        
        func load() async throws -> [Stop] {
            let request = createRequest(for: route)
            let (data, _) = try await URLSession.shared.data(for: request)
            return try await decode(data)
        }
        
        private func createRequest(for route: Route) -> URLRequest {
            let url = baseURL
                .appendingPathComponent("route-stop")
                .appendingPathComponent(route._id)
                .appendingPathComponent(route.direction.sequence)
            return URLRequest(url: url)
        }
        
        private func decode(_ data: Data) async throws -> [Stop] {
            let task = Task { () -> [Stop] in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601FractionalSeconds
                let rawStop = try decoder.decode(RawStop.self, from: data)
                return rawStop.stops
            }
            return try await task.value
        }
    }
}
