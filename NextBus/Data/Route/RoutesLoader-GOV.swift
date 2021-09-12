//
//  RoutesLoader-GOV.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

extension GOV {
    class RoutesLoader: SpecificLoader {
        private let category: Category
        
        private let urlMethod = "routes"
        
        required init(key category: Category) {
            self.category = category
        }
        
        func load() async throws -> [Route] {
            let request = createRequest()
            let (data, _) = try await URLSession.shared.data(for: request)
            var routes = try await decode(data)
            routes = routes.filter {
                ![Company.ctb, .gmb, .nlb, .nwfb].contains($0.company)
            }
            return routes
        }
        
        private func createRequest() -> URLRequest {
            let url = baseURL
                .appendingPathComponent(category.urlKey)
                .appendingPathComponent(urlMethod)
            return URLRequest(url: url)
        }
        
        private func decode(_ data: Data) async throws -> [Route] {
            let task = Task { () -> [Route] in
                let decoder = JSONDecoder()
                let rawRoutes = try decoder.decode([GOV.RawRoute].self, from: data)
                return rawRoutes.flatMap { $0.routes }
            }
            return try await task.value
        }
    }
}
