//
//  RoutingLoader.swift
//  NextBus
//
//  Created by Julian Schiavo on 27/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation
import Loadability

class RoutingLoader: Loader {
    typealias Key = RoutingRequest
    
    @Published var object: [Routing]?
    @Published var error: IdentifiableError?
    
    var cancellable: AnyCancellable?
    
    required init() {
        
    }
    
    func createPublisher(key request: RoutingRequest) -> AnyPublisher<[Routing], Error>? {
        let urlRequest = createRequest(for: request)
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .retry(3)
            .tryMap { data, response in
                try self.decode(data, key: request)
            }
            .flatMap { response -> AnyPublisher<[Routing], Error> in
                let publishers = response.map(self.createStopsPublisher)
                return Publishers.MergeMany(publishers)
                    .collect()
                    .eraseToAnyPublisher()
            }
            .map(generateWalkingSteps)
            .map { response in
                response.sorted { $0.index < $1.index }
            }
            .eraseToAnyPublisher()
    }
    
    private func createRequest(for request: RoutingRequest) -> URLRequest {
        var request = URLRequest.postRequest(url: GOV.directionsURL, body: request)
        request.setValue("https://www.hkemobility.gov.hk/en/route-search/pt", forHTTPHeaderField: "Referer")
        return request
    }
    
    private func decode(_ data: Data, key request: RoutingRequest) throws -> [Routing] {
        do {
            return try JSONDecoder().decode([RawRouting].self, from: data)
                .map {
                    Routing.from($0, origin: request.origin, destination: request.destination)
                }
        } catch {
            let raw = try JSONDecoder().decode(RawRouting.self, from: data)
            return [Routing.from(raw, origin: request.origin, destination: request.destination)]
        }
    }
    
    func createStopsPublisher(for directions: Routing) -> AnyPublisher<Routing, Error> {
        let request = RoutingStopsRequest(routing: directions)
        let urlRequest = createStopsRequest(for: request)
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .retry(3)
            .tryMap { data, response in
                try self.decodeStops(data)
            }
            .map { response in
                var directions = directions
                directions.tracks = response.routes.compactMap { route in
                    guard var routing = directions.tracks.first(where: { $0.index == route.index }) else { return nil }
                    routing.stops = route.stops
                    return routing
                }
                return directions
            }
            .eraseToAnyPublisher()
    }
    
    private func createStopsRequest(for request: RoutingStopsRequest) -> URLRequest {
        var request = URLRequest.postRequest(url: GOV.directionsURL, body: request)
        request.setValue("https://www.hkemobility.gov.hk/en/route-search/pt", forHTTPHeaderField: "Referer")
        return request
    }
    
    private func decodeStops(_ data: Data) throws -> RoutingStopsResponse {
        try JSONDecoder().decode(RoutingStopsResponse.self, from: data)
    }
    
    private func generateWalkingSteps(routings: [Routing]) -> [Routing] {
        routings.map { routing in
            var new = routing
            new.tracks = [RoutingTrack]()
            
            if var firstTrack = routing.tracks.first {
                let walkToStart = RoutingTrack.between(routing.origin, and: firstTrack.origin, index: new.tracks.indices.count)
                new.tracks.append(walkToStart)
                firstTrack.index = new.tracks.indices.count
                new.tracks.append(firstTrack)
            }
            
            for (i, var track) in routing.tracks.enumerated() where routing.tracks.count > 1 && i != routing.tracks.indices.first {
                let index = routing.tracks.index(before: i)
                let previous = routing.tracks[index]
                let walk = RoutingTrack.between(previous.destination, and: track.origin, index: new.tracks.indices.count)
                new.tracks.append(walk)
                track.index = new.tracks.indices.count
                new.tracks.append(track)
            }
            
            if var lastTrack = routing.tracks.last {
                if routing.tracks.first != lastTrack {
                    lastTrack.index = new.tracks.indices.count
                    new.tracks.append(lastTrack)
                }
                let walkToEnd = RoutingTrack.between(lastTrack.destination, and: routing.destination, index: new.tracks.indices.count)
                new.tracks.append(walkToEnd)
            }
            
            new.tracks = new.tracks
                .sorted { $0.index < $1.index }
                .removingDuplicates()
            
            return new
        }
        .removingDuplicates()
        .sorted { $0.index < $1.index }
    }
}
