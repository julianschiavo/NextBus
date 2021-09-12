//
//  RoutesLoader-NLB.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

extension NLB {
    class RoutesLoader: SpecificLoader {
        required init(key category: Category) {
            
        }
        
        func load() async throws -> [Route] {
            let request = createRequest()
            let (data, _) = try await URLSession.shared.data(for: request)
            return try await decode(data)
        }
        
        private func createRequest() -> URLRequest {
            let baseURL = NLB.baseURL.appendingPathComponent("route.php")
            
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
            components?.queryItems = [URLQueryItem(name: "action", value: "list")]
            
            guard let url = components?.url else { fatalError("Invalid URLComponents Object") }
            return URLRequest(url: url)
        }
        
        private func decode(_ data: Data) async throws -> [Route] {
            let task = Task { () -> [Route] in
                let decoder = JSONDecoder()
                let rawRoutes = try decoder.decode(NLB.RawRoute.self, from: data)
                return rawRoutes.routes
            }
            return try await task.value
        }
    }
}
