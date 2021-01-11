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
    class RoutesLoader: RoutesLoaderVariant {
        
        private let category: Category
        
        private let urlMethod = "routes"
        
        required init(category: Category) {
            self.category = category
        }
        
        func createPublisher() -> AnyPublisher<[Route], Error> {
            let request = createRequest()
            return URLSession.shared
                .dataTaskPublisher(for: request)
                .retry(3)
                .tryMap { data, response in
                    try self.decode(data)
                }
                .map { routes in
                    routes.filter {
                        ![CompanyID.ctb, .gmb, .nlb, .nwfb].contains($0.companyID)
                    }
                }
                .eraseToAnyPublisher()
        }
        
        private func createRequest() -> URLRequest {
            let url = baseURL
                .appendingPathComponent(category.urlKey)
                .appendingPathComponent(urlMethod)
            print(url)
            return URLRequest(url: url)
        }
        
        private func decode(_ data: Data) throws -> [Route] {
            let decoder = JSONDecoder()
            let rawRoutes = try decoder.decode([GOV.RawRoute].self, from: data)
            return rawRoutes.flatMap { $0.route }
        }
    }
}
