//
//  RoutingStopsResponse.swift
//  NextBus
//
//  Created by Julian Schiavo on 28/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

struct RoutingStopsResponse: Codable {
    struct Route: Codable {
        let index: Int
        let stops: [RoutingStop]
        
        enum CodingKeys: String, CodingKey {
            case index = "ROUTE_SEQ"
            case stops = "STOPS"
        }
    }
    
    let routes: [Route]
    
    enum CodingKeys: String, CodingKey {
        case routes = "ROUTES"
    }
}
