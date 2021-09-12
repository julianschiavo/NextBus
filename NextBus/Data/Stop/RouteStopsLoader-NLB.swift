//
//  RouteStopsLoader-NLB.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

extension NLB {
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
            let initialURL = baseURL
                .appendingPathComponent("stop.php")
            
            var components = URLComponents(url: initialURL, resolvingAgainstBaseURL: false)
            components?.queryItems = [URLQueryItem(name: "action", value: "list")]
            
            guard let url = components?.url else { fatalError("Invalid URLComponents Object") }
            
            let requestData = NLB.StopRequest(routeId: route._id)
            return .postRequest(url: url, body: requestData)
        }
        
        private func decode(_ data: Data) async throws -> [Stop] {
            let task = Task { () -> [Stop] in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(.dateSpaceTime)
                let rawStop = try decoder.decode(RawStop.self, from: data)
                return rawStop.stops
            }
            return try await task.value
        }
    }
}
