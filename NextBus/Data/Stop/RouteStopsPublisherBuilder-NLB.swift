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
    class RouteStopsPublisherBuilder: PublisherBuilder, RouteStopsLoader.PublisherBuilder {
        private let route: Route
        
        required init(key route: Route) {
            self.route = route
        }
        
        func create() -> AnyPublisher<[Stop], Error> {
            let urlRequest = createRequest(for: route)
            
            return URLSession.shared
                .dataTaskPublisher(for: urlRequest)
                .retry(3)
                .tryMap { data, response in
                    try self.decode(data)
                }
                .eraseToAnyPublisher()
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
        
        func decode(_ data: Data) throws -> [Stop] {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(.dateSpaceTime)
            let rawStop = try decoder.decode(RawStop.self, from: data)
            return rawStop.stops
        }
    }
}