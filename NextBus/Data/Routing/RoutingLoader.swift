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
    @Published var error: Error?
    
    var cancellable: AnyCancellable?
    var task: Task<[Routing], Error>?
    
    required init() {
        
    }
    
    func loadData(key request: RoutingRequest) async throws -> [Routing] {
        let urlRequest = createRequest(for: request)
        
        let (rawRoutingsData, _) = try await URLSession.shared.data(for: urlRequest)
        let rawRoutings = try await decode(rawRoutingsData, key: request)
        
        var routings = try await withThrowingTaskGroup(of: Routing.self) { group -> [Routing] in
            rawRoutings.forEach { rawRouting in
                group.addTask {
                    var rawRouting = rawRouting
                    
                    let stopsRequest = RoutingStopsRequest(routing: rawRouting)
                    let stopsURLRequest = await self.createStopsRequest(for: stopsRequest)
                    let (data, _) = try await URLSession.shared.data(for: stopsURLRequest)
                    let stops = try await self.decodeStops(data)
                    
                    rawRouting.tracks = stops.routes.compactMap { route in
                        guard var routing = rawRouting.tracks.first(where: { $0.index == route.index }) else { return nil }
                        routing.stops = route.stops
                        return routing
                    }
                    return rawRouting
                }
            }
            
            var routings = [Routing]()
            for try await value in group {
                routings.append(value)
            }
            return routings
        }
        
        routings = await generateWalkingSteps(routings: routings)
        routings.sort { $0.index < $1.index }
        
        return routings
    }
    
    private func createRequest(for request: RoutingRequest) -> URLRequest {
        var request = URLRequest.postRequest(url: GOV.directionsURL, body: request)
        request.setValue("https://www.hkemobility.gov.hk/en/route-search/pt", forHTTPHeaderField: "Referer")
        return request
    }
    
    private func decode(_ data: Data, key request: RoutingRequest) async throws -> [Routing] {
        let task = Task { () -> [Routing] in
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
        return try await task.value
    }
    
    private func createStopsRequest(for request: RoutingStopsRequest) -> URLRequest {
        var request = URLRequest.postRequest(url: GOV.directionsURL, body: request)
        request.setValue("https://www.hkemobility.gov.hk/en/route-search/pt", forHTTPHeaderField: "Referer")
        return request
    }
    
    private func decodeStops(_ data: Data) async throws -> RoutingStopsResponse {
        let task = Task { () -> RoutingStopsResponse in
            try JSONDecoder().decode(RoutingStopsResponse.self, from: data)
        }
        return try await task.value
    }
    
    private func generateWalkingSteps(routings: [Routing]) async -> [Routing] {
        let task = Task { () -> [Routing] in
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
        return await task.value
    }
}
