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
    class RoutesLoader: SpecificLoader {
        required init(key category: Category) {
            
        }
        
        func load() async throws -> [Route] {
            let unknownRoutes = try await loadUnknownRoutes()
            return try await loadRoutes(unknownRoutes: unknownRoutes)
        }
        
        private func loadRoutes(unknownRoutes: [UnknownRoute]) async throws -> [Route] {
            try await withThrowingTaskGroup(of: [Route].self) { group in
                unknownRoutes.forEach { unknownRoute in
                    group.addTask {
                        let request = await self.createRequest(route: unknownRoute)
                        let (data, _) = try await URLSession.shared.data(for: request)
                        var routes = try await self.decode(data)
                        for i in routes.indices {
                            routes[i].name = LocalizedText(unknownRoute.name)
                        }
                        return routes
                    }
                }
                
                var routes = [Route]()
                for try await value in group {
                    routes.append(contentsOf: value)
                }
                return routes
            }
        }
        
        private func loadUnknownRoutes() async throws -> [UnknownRoute] {
            let request = createUnknownRequest()
            let (data, _) = try await URLSession.shared.data(for: request)
            return try await decodeUnknown(data)
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
        
        private func decodeUnknown(_ data: Data) async throws -> [UnknownRoute] {
            let task = Task { () -> [UnknownRoute] in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601FractionalSeconds
                let rawRoutes = try decoder.decode(RawUnknownRoute.self, from: data)
                return rawRoutes.routes
            }
            return try await task.value
        }
        
        private func decode(_ data: Data) async throws -> [Route] {
            let task = Task { () -> [Route] in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601FractionalSeconds
                let rawRoutes = try decoder.decode(RawRoute.self, from: data)
                return rawRoutes.routes
            }
            return try await task.value
        }
    }
}
