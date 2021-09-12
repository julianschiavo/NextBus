//
//  ETALoader-CTBNWFB.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

extension CTBNWFB {
    class ETALoader: SpecificLoader, ETASpecificLoader {
        private let route: Route
        private let stop: Stop
        
        required init(key routeStop: RouteStop) {
            self.route = routeStop.route
            self.stop = routeStop.stop
        }
        
        func load() async throws -> [ETA] {
            let request = createRequest()
            let (data, _) = try await URLSession.shared.data(for: request)
            return try await decode(data)
        }
        
        private func createRequest() -> URLRequest {
            let url = baseURL
                .appendingPathComponent("eta")
                .appendingPathComponent(route.company.rawValue)
                .appendingPathComponent(stop.id)
                .appendingPathComponent(route.localizedName)
            return URLRequest(url: url)
        }
        
        private func decode(_ data: Data) async throws -> [ETA] {
            let task = Task { () -> [ETA] in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let rawETA = try decoder.decode(RawETA.self, from: data)
                return rawETA.etas(for: route.direction)
            }
            return try await task.value
        }
    }
}
