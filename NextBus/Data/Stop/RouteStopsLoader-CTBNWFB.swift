//
//  RouteStopsLoader-CTBNWFB.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

extension CTBNWFB {
    class RouteStopsLoader: SpecificLoader, RouteStopsSpecificLoader {
        private let route: Route
        
        required init(key route: Route) {
            self.route = route
        }
        
        func load() async throws -> [Stop] {
            let unknownStops = try await loadUnknownStops()
            return try await loadStops(unknownStops)
        }
        
        private func loadUnknownStops() async throws -> [UnknownStop] {
            let request = createUnknownRequest()
            let (data, _) = try await URLSession.shared.data(for: request)
            return try await decodeUnknown(data)
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
        
        private func decodeUnknown(_ data: Data) async throws -> [UnknownStop] {
            let task = Task { () -> [UnknownStop] in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let rawUnknownStop = try decoder.decode(RawUnknownStop.self, from: data)
                return rawUnknownStop.unknownStops
            }
            return try await task.value
        }
        
        private func loadStops(_ unknownStops: [UnknownStop]) async throws -> [Stop] {
            let idOrder = unknownStops.map(\.id)
            var stops = try await withThrowingTaskGroup(of: [Stop].self) { group -> [Stop] in
                unknownStops.forEach { unknownStop in
                    group.addTask {
                        [try await self.loadStop(for: unknownStop)]
                    }
                }
                
                var stops = [Stop]()
                for try await value in group {
                    stops.append(contentsOf: value)
                }
                return stops
            }
            
            stops = stops.reorder(using: idOrder)
            
            for i in 0..<stops.count {
                stops[i].index = i + 1
            }
            
            return stops
        }
        
        private func loadStop(for unknownStop: UnknownStop) async throws -> Stop {
            let request = createRequest(for: unknownStop)
            let (data, _) = try await URLSession.shared.data(for: request)
            return try await decode(data)
        }
        
        private func createRequest(for unknownStop: UnknownStop) -> URLRequest {
            let url = baseURL
                .appendingPathComponent("stop")
                .appendingPathComponent(unknownStop.id)
            return URLRequest(url: url)
        }
        
        private func decode(_ data: Data) async throws -> Stop {
            let task = Task { () -> Stop in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let rawStop = try decoder.decode(RawStop.self, from: data)
                return rawStop.stop
            }
            return try await task.value
        }
    }
}
