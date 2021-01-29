//
//  RoutesPublisherBuilder-CTBNWFB.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

extension CTBNWFB {
    class RoutesPublisherBuilder: PublisherBuilder {

        required init(key category: Category) {
            
        }
        
        func create() -> AnyPublisher<[Route], Error> {
            let publishers = [createCTBPublisher(), createNWFBPublisher()]
            return Publishers.MergeMany(publishers)
                .collect()
                .map { $0.flatMap { $0 } }
                .eraseToAnyPublisher()
        }
        
        private func createCTBPublisher() -> AnyPublisher<[Route], Error> {
            let request = createCTBRequest()
            return URLSession.shared
                .dataTaskPublisher(for: request)
                .retry(3)
                .tryMap { data, response in
                    try self.decode(data)
                }
                .eraseToAnyPublisher()
        }
        
        private func createNWFBPublisher() -> AnyPublisher<[Route], Error> {
            let request = createNWFBRequest()
            return URLSession.shared
                .dataTaskPublisher(for: request)
                .retry(3)
                .tryMap { data, response in
                    try self.decode(data)
                }
                .eraseToAnyPublisher()
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
        
        private func decode(_ data: Data) throws -> [Route] {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let rawRoutes = try decoder.decode(RawRoute.self, from: data)
            return rawRoutes.routes
        }
    }
}
