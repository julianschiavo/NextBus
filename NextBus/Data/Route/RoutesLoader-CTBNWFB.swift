//
//  RoutesLoader-CTBNWFB.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

extension CTBNWFB {
    class RoutesLoader: SpecificLoader {

        required init(key category: Category) {
            
        }
        
        func load() async throws -> [Route] {
            async let ctbRoutes = loadCTB()
            async let nwfbRoutes = loadNWFB()
            return try await ctbRoutes + nwfbRoutes
        }
        
        private func loadCTB() async throws -> [Route] {
            let request = createCTBRequest()
            let (data, _) = try await URLSession.shared.data(for: request)
            return try await decode(data)
        }
        
        private func loadNWFB() async throws -> [Route] {
            let request = createNWFBRequest()
            let (data, _) = try await URLSession.shared.data(for: request)
            return try await decode(data)
        }
        
        private func createCTBRequest() -> URLRequest {
            let url = CTBNWFB.baseURL
                .appendingPathComponent("route")
                .appendingPathComponent(Company.ctb.rawValue)
            return URLRequest(url: url)
        }
        
        private func createNWFBRequest() -> URLRequest {
            let url = CTBNWFB.baseURL
                .appendingPathComponent("route")
                .appendingPathComponent(Company.nwfb.rawValue)
            return URLRequest(url: url)
        }
        
        private func decode(_ data: Data) async throws -> [Route] {
            let task = Task { () -> [Route] in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let rawRoutes = try decoder.decode(RawRoute.self, from: data)
                return rawRoutes.routes
            }
            return try await task.value
        }
    }
}
