//
//  DirectionsLoader.swift
//  NextBus
//
//  Created by Julian Schiavo on 27/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

class DirectionsLoader: Loader {
    typealias Key = DirectionsRequest
    
    @Published var object: [Routing]?
    @Published var error: IdentifiableError?
    
    private var tempObject: [Routing]?
    var cancellable: AnyCancellable?
    
    required init() {
        
    }
    
    func createPublisher(key request: DirectionsRequest) -> AnyPublisher<[Routing], Error>? {
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
            .map { directions in
                directions.map { directions in
                    var new = directions
                    guard let first = new.tracks.first, let last = new.tracks.last, first != last else { return directions }
                    var routings = [first]
                    for (i, next) in new.tracks.enumerated() where next != new.tracks.first && next != new.tracks.last {
                        let previous = new.tracks[new.tracks.index(before: i)]
                        let walk = RoutingTrack(
                            company: "",
                            companyName: "",
                            id: Int.random(in: 999...999999),
                            index: routings.indices.last ?? -1 + 1,
                            name: "Walk",
                            type: 0,
                            mode: 0,
                            originID: previous.destinationID,
                            originName: previous.destinationName,
                            originIndex: previous.originIndex,
                            originLatitude: previous.originLatitude,
                            originLongitude: previous.originLongitude,
                            destinationID: next.destinationID,
                            destinationName: next.destinationName,
                            destinationIndex: next.destinationIndex,
                            destinationLatitude: next.destinationLatitude,
                            destinationLongitude: next.destinationLongitude,
                            elderlyPaymentMode: 0,
                            fareRemark: "",
                            specialType: 5,
                            url: nil
                        )
                        routings.append(walk)
                        routings.append(next)
                    }
                    routings.append(last)
                    new.tracks = routings
                    return new
                }
            }
            .map { response in
                response.sorted { $0.timeSortedIndex < $1.timeSortedIndex }
            }
            .eraseToAnyPublisher()
    }
    
    private func createRequest(for request: DirectionsRequest) -> URLRequest {
        var request = URLRequest.postRequest(url: GOV.directionsURL, body: request)
        request.setValue("https://www.hkemobility.gov.hk/en/route-search/pt", forHTTPHeaderField: "Referer")
        return request
    }
    
    private func decode(_ data: Data, key: DirectionsRequest) throws -> [Routing] {
        do {
            return try JSONDecoder().decode([Routing].self, from: data)
        } catch {
            return [try JSONDecoder().decode(Routing.self, from: data)]
        }
    }
    
    func createStopsPublisher(for directions: Routing) -> AnyPublisher<Routing, Error> {
        let request = DirectionsStopsRequest(directions: directions)
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
    
    private func createStopsRequest(for request: DirectionsStopsRequest) -> URLRequest {
        var request = URLRequest.postRequest(url: GOV.directionsURL, body: request)
        request.setValue("https://www.hkemobility.gov.hk/en/route-search/pt", forHTTPHeaderField: "Referer")
        return request
    }
    
    private func decodeStops(_ data: Data) throws -> DirectionsStopsResponse {
        try JSONDecoder().decode(DirectionsStopsResponse.self, from: data)
    }
    
}
