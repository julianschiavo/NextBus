//
//  GeoPathLoader.swift
//  NextBus
//
//  Created by Julian Schiavo on 29/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation
import MapKit

class GeoPathLoader: Loader {
    @Published var object: [RoutingPath]?
    @Published var error: IdentifiableError?
    
    var cancellable: AnyCancellable?
    var cancellables = Set<AnyCancellable>()
    
    required init() {
        
    }
    
    func createPublisher(key directions: Directions) -> AnyPublisher<[RoutingPath], Error>? {
        Just(directions.tracks)
            .flatMap { tracks -> AnyPublisher<[RoutingPath], Error> in
                let publishers = tracks
                    .flatMap { track in
                        self.requests(for: track)
                            .map { request in
                                self.createPathPublisher(for: track, request: request)
                            }
                    }
                return Publishers.MergeMany(publishers)
                    .collect()
                    .map { paths in
                        Dictionary(grouping: paths, by: \.track)
                            .map { track, path in
                                RoutingPath(track: track, polylines: path.map(\.polyline))
                            }
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func createPathPublisher(for track: RoutingTrack, request: MKDirections.Request) -> AnyPublisher<(track: RoutingTrack, polyline: MKPolyline), Error> {
        Future { promise in
            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                guard let route = response?.routes.first else {
                    promise(.failure(error ?? Errors.unknown))
                    return
                }
                
                let polyline = route.polyline
                let response = (track: track, polyline: polyline)
                promise(.success(response))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func requests(for track: RoutingTrack) -> [MKDirections.Request] {
        guard !track.stops.isEmpty else {
            return [request(from: origin(for: track), to: destination(for: track), type: track.specialType == 5 ? .walking : .automobile)]
        }
        
        var requests = [MKDirections.Request]()
        for (i, stop) in track.stops.enumerated() where i != track.stops.indices.first {
            let previousStopIndex = track.stops.index(before: i)
            let previousStop = track.stops[previousStopIndex]
            
            let origin = item(latitude: previousStop.latitude, longitude: previousStop.longitude)
            let destination = item(latitude: stop.latitude, longitude: stop.longitude)
            let request = self.request(from: origin, to: destination)
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
    
    private func origin(for track: RoutingTrack) -> MKMapItem {
        let coordinate = CLLocationCoordinate2D(latitude: track.originLatitude, longitude: track.originLongitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        return MKMapItem(placemark: placemark)
    }
    
    private func destination(for track: RoutingTrack) -> MKMapItem {
        let coordinate = CLLocationCoordinate2D(latitude: track.destinationLatitude, longitude: track.destinationLongitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        return MKMapItem(placemark: placemark)
    }
    
    private func item(latitude: Double, longitude: Double) -> MKMapItem {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        return MKMapItem(placemark: placemark)
    }
}

