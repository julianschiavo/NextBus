//
//  ETALoader-KMB.swift
//  NextBus
//
//  Created by Julian Schiavo on 11/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

extension KMB {
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
                .appendingPathComponent("kmb")
                .appendingPathComponent("eta")
                .appendingPathComponent(LocalizedText.kmbLanguageCode)
                .appendingPathComponent(route.localizedName)
                .appendingPathComponent(route.direction.sequence)
                .appendingPathComponent(String(stop.index))
            print(url)
            return URLRequest(url: url)
        }
        
        private func decode(_ data: Data) async throws -> [ETA] {
            let task = Task { () -> [ETA] in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601FractionalSeconds
                let rawETA = try decoder.decode([_ETA].self, from: data)
                return rawETA.map(ETA.from)
            }
            return try await task.value
        }
    }
}
