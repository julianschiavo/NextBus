//
//  ETALoader-NLB.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

extension NLB {
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
            let initialURL = NLB.baseURL.appendingPathComponent("stop.php")
            
            var components = URLComponents(url: initialURL, resolvingAgainstBaseURL: false)
            components?.queryItems = [URLQueryItem(name: "action", value: "estimatedArrivals")]
            
            guard let url = components?.url else { fatalError("Invalid URLComponents Object") }
            
            let requestData = NLB.ETARequest(routeId: route._id, stopId: stop.id)
            return .postRequest(url: url, body: requestData)
        }
        
        private func decode(_ data: Data) async throws -> [ETA] {
            let task = Task { () -> [ETA] in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(.dateSpaceTime)
                
                let rawETA = try decoder.decode(NLB.RawETA.self, from: data)
                let etas = rawETA.etas(for: route)
                return Array(etas)
            }
            return try await task.value
        }
    }
}
