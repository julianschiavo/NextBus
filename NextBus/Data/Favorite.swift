//
//  RouteStop.swift
//  NextBus
//
//  Created by Julian Schiavo on 14/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation

struct RouteStop: Codable, Equatable, Identifiable, Hashable {
    var companyID: CompanyID
    var route: Route
    var stop: Stop
    
    var id: String { route.id + stop.id }
    
    init(route: Route, stop: Stop) {
        self.companyID = route.companyID
        self.route = route
        self.stop = stop
    }
}
