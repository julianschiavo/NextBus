//
//  Favorite.swift
//  NextBus
//
//  Created by Julian Schiavo on 14/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation

struct Favorite: Codable, Equatable, Hashable {
    var companyID: CompanyID
    var routeID: String
    var routeName: String
    var direction: Direction
    var stopID: String
    
    init(route: Route, direction: Direction, stop: Stop) {
        self.companyID = route.companyID
        self.routeID = route.id
        self.routeName = route.name
        self.direction = direction
        self.stopID = stop.id
    }
}
