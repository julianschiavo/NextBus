//
//  RouteStopsLoader-GOV.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

extension GOV {
    class RouteStopsLoader: SpecificLoader, RouteStopsSpecificLoader {
        private let route: Route
        
        private let urlMethod = "stops"
        
        required init(key route: Route) {
            self.route = route
        }
        
        func load() async throws -> [Stop] {
            let request = createRequest()
            let (data, _) = try await URLSession.shared.data(for: request)
            return try await decode(data)
        }
        
        private func createRequest() -> URLRequest {
            let url = baseURL
                .appendingPathComponent(route.category.urlKey)
                .appendingPathComponent(urlMethod)
                .appendingPathComponent(route._id)
            return URLRequest(url: url)
        }
        
        private func decode(_ data: Data) async throws -> [Stop] {
            let task = Task { () -> [Stop] in
                let decoder = JSONDecoder()
                let rawStops = try decoder.decode([RawStop].self, from: data)
                return rawStops
                    .filter { Direction.fromGovSequence($0.direction) == route.direction }
                    .map { $0.stop }
                    .sorted { $0.index < $1.index }
            }
            return try await task.value
        }
    }
}
