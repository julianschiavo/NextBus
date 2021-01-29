//
//  ETAPublisherBuilder-NLB.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

extension NLB {
    class ETAPublisherBuilder: PublisherBuilder, ETALoader.PublisherBuilder {
        private let route: Route
        private let stop: Stop
        
        required init(key routeStop: RouteStop) {
            self.route = routeStop.route
            self.stop = routeStop.stop
        }
        
        func create() -> AnyPublisher<[ETA], Error> {
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
            let initialURL = NLB.baseURL.appendingPathComponent("stop.php")
            
            var components = URLComponents(url: initialURL, resolvingAgainstBaseURL: false)
            components?.queryItems = [URLQueryItem(name: "action", value: "estimatedArrivals")]
            
            guard let url = components?.url else { fatalError("Invalid URLComponents Object") }
            
            let requestData = NLB.ETARequest(routeId: route._id, stopId: stop.id)
            return .postRequest(url: url, body: requestData)
        }
        
        private func decode(_ data: Data) throws -> [ETA] {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(.dateSpaceTime)
            
            let rawETA = try decoder.decode(NLB.RawETA.self, from: data)
            let etas = rawETA.etas(for: route)
            return Array(etas)
        }
    }
}
