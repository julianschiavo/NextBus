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
    class RoutesLoader: RoutesLoaderVariant {
        
        required init(category: Category) {
            
        }
        
        func createPublisher() -> AnyPublisher<[Route], Error> {
            let request = createRequest()
            return URLSession.shared
                .dataTaskPublisher(for: request)
                .retry(3)
                .tryMap { data, response in
                    try self.decode(data)
                }
                .eraseToAnyPublisher()
        }
        
        private func createRequest() -> URLRequest {
            let baseURL = NLB.baseURL.appendingPathComponent("route.php")
            
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
            components?.queryItems = [URLQueryItem(name: "action", value: "list")]
            
            guard let url = components?.url else { fatalError("Invalid URLComponents Object") }
            return URLRequest(url: url)
        }
        
        private func decode(_ data: Data) throws -> [Route] {
            let decoder = JSONDecoder()
            let rawRoutes = try decoder.decode(NLB.RawRoute.self, from: data)
            return rawRoutes.routes
        }
    }
}
