//
//  Routing.swift
//  NextBus
//
//  Created by Julian Schiavo on 27/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation
import MapKit

struct Routing: Equatable, Hashable, Identifiable {
    var id = UUID()
    let index: Int
    
    let origin: Waypoint
    let destination: Waypoint
    
    var tracks: [RoutingTrack]
    let travelTime: Int
    let price: Double
}

extension Routing {
    static func from(_ routing: RawRouting, origin: Waypoint, destination: Waypoint) -> Routing {
        Routing(index: routing.timeSortedIndex, origin: origin, destination: destination, tracks: routing.tracks.map(\.track), travelTime: routing.travelTime, price: routing.price)
    }
}

struct RawRouting: Codable {
    let tracks: [RawRoutingTrack]
    let travelTime: Int
    let price: Double
    
    let sortedIndex: Int
    let timeSortedIndex: Int
    let priceSortedIndex: Int
    
    enum CodingKeys: String, CodingKey {
        case tracks = "ROUTES"
        case travelTime = "TOTAL_IMPED"
        case price = "PRICE"
        case sortedIndex = "SORT_DEFAULT"
        case timeSortedIndex = "SORT_TIME"
        case priceSortedIndex = "SORT_PRICE"
    }
}
