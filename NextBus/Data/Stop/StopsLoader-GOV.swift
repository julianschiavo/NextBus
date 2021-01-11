//
//  GOV-StopsLoader.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

extension GOV {
    class StopsLoader: StopsLoaderVariant {
        
        private let urlMethod = "stops"
        
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
            let urlRequest = createRequest()
            
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
        
        private func createRequest() -> URLRequest {
            let url = baseURL
                .appendingPathComponent(route.category.urlKey)
                .appendingPathComponent(urlMethod)
                .appendingPathComponent(route._id)
            return URLRequest(url: url)
        }
        
        private func decode(_ data: Data) throws -> [Stop] {
            let decoder = JSONDecoder()
            let rawStops = try decoder.decode([RawStop].self, from: data)
            return rawStops
                .filter { Direction.fromGovSequence($0.direction) == route.direction }
                .map { $0.stop }
                .sorted { $0.index < $1.index }
        }
        
        override func cancel() {
            cancellable?.cancel()
        }
    }
}
