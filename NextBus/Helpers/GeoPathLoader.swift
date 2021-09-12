//
//  GeoPathLoader.swift
//  NextBus
//
//  Created by Julian Schiavo on 29/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation
import Loadability
import MapKit

class GeoPathLoader: Loader {
    @Published var object: [RoutingPath]?
    @Published var error: Error?
    
    var cancellable: AnyCancellable?
    var cancellables = Set<AnyCancellable>()
    var task: Task<[RoutingPath], Error>?
    
    required init() {
        
    }
    
    func loadData(key routing: Routing) async throws -> [RoutingPath] {
        try await withThrowingTaskGroup(of: (track: RoutingTrack, polyline: MKPolyline).self) { group -> [RoutingPath] in
            let tracks = routing.tracks
            
            for track in tracks {
                let task = Task { () -> [MKDirections.Request] in
                    self.requests(for: track)
                }
                let requests = await task.value
                for request in requests {
                    group.async {
                        try await self.path(for: track, request: request)
                    }
                }
            }
            
            var paths = [(track: RoutingTrack, polyline: MKPolyline)]()

            for try await path in group {
                paths.append(path)
            }
            
            return Dictionary(grouping: paths, by: \.track)
                .map { track, path in
                    RoutingPath(track: track, polylines: path.map(\.polyline))
                }
        }
    }
    
    private func path(for track: RoutingTrack, request: MKDirections.Request) async throws -> (track: RoutingTrack, polyline: MKPolyline) {
        let directions = MKDirections(request: request)
        let response = try await directions.calculate()
        
        guard let route = response.routes.first else {
            throw error ?? Errors.unknown
        }
        
        let polyline = route.polyline
        return (track: track, polyline: polyline)
    }
    
    private func requests(for track: RoutingTrack) -> [MKDirections.Request] {
        guard !track.stops.isEmpty else {
            return [request(from: track.origin.mapItem, to: track.destination.mapItem, type: track.isWalking ? .walking : .automobile)]
        }
        
        var requests = [MKDirections.Request]()
        for (i, stop) in track.stops.enumerated() where i != track.stops.indices.first {
            let previousStopIndex = track.stops.index(before: i)
            let previousStop = track.stops[previousStopIndex]
            
            let origin = item(latitude: previousStop.latitude, longitude: previousStop.longitude)
            let destination = item(latitude: stop.latitude, longitude: stop.longitude)
            let request = self.request(from: origin, to: destination, type: track.isWalking ? .walking : .automobile)
            requests.append(request)
        }
        return requests
    }
    
    private func request(from source: MKMapItem, to destination: MKMapItem, type: MKDirectionsTransportType = .automobile) -> MKDirections.Request {
        let request = MKDirections.Request()
        request.source = source
        request.destination = destination
        request.transportType = type
        request.requestsAlternateRoutes = false
        return request
    }
    
    private func item(latitude: Double, longitude: Double) -> MKMapItem {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        return MKMapItem(placemark: placemark)
    }
}

