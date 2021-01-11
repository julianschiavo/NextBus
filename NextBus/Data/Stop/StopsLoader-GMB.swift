//
//  StopsLoader-GMB.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

extension GMB {
    class StopsLoader: StopsLoaderVariant {
        
        private let route: Route
        private var cancellable: AnyCancellable?
        
        required init(key: Route) {
            self.route = key
            super.init(key: key)
        }
        
        deinit {
            cancel()
        }
        
        override func load() {
            let urlRequest = createRequest(for: route)
            cancellable = URLSession.shared
                .dataTaskPublisher(for: urlRequest)
                .retry(3)
                .tryMap { data, response in
                    try self.decode(data)
                }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    self?.catchCompletionError(completion)
                } receiveValue: { [weak self] object in
                    self?.object = object
                }
        }
        
        private func createRequest(for route: Route) -> URLRequest {
            let url = baseURL
                .appendingPathComponent("route-stop")
                .appendingPathComponent(route._id)
                .appendingPathComponent(route.direction.sequence)
            return URLRequest(url: url)
        }
        
        private func decode(_ data: Data) throws -> [Stop] {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601FractionalSeconds
            let rawStop = try decoder.decode(RawStop.self, from: data)
            return rawStop.stops
        }
        
        override func cancel() {
            cancellable?.cancel()
        }
    }
}
