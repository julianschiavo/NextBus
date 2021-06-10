//
//  RoutingStop.swift
//  NextBus
//
//  Created by Julian Schiavo on 28/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

struct RoutingStop: Codable, Equatable, Hashable, Identifiable {
    let id: Int
    let index: Int
    let name: String
    
    let routingName: String
    
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "STOP_ID"
        case index = "STOP_SEQ"
        case name = "STOP_NM"
        case routingName = "ROUTE_NM"
        case latitude = "LAT"
        case longitude = "LNG"
    }
}
