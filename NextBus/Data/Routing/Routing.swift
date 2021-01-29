//
//  Routing.swift
//  NextBus
//
//  Created by Julian Schiavo on 27/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation
import MapKit

struct Routing: Codable, Equatable, Hashable, Identifiable {
    let id = UUID()
    
    var tracks: [RoutingTrack]
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
