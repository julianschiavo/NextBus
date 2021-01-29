//
//  RouteStop.swift
//  NextBus
//
//  Created by Julian Schiavo on 14/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation
import Intents

struct RouteStop: Codable, Equatable, Identifiable, Hashable {
    var companyID: Company
    var route: Route
    var stop: Stop
    
    var id: String { route.id + stop.id }
    
    init(route: Route, stop: Stop) {
        self.companyID = route.company
        self.route = route
        self.stop = stop
    }
    
    var intent: INRouteStop {
        let intent = INRouteStop(identifier: id, display: route.localizedName + " from " + stop.localizedName)
        intent.route = route.intent
        intent.stop = stop.intent
        return intent
    }
    
    static func from(_ intent: INRouteStop) -> Self? {
        guard let inRoute = intent.route,
              let route = Route.from(inRoute),
              let inStop = intent.stop,
              let stop = Stop.from(inStop) else { return nil }
        return RouteStop(route: route, stop: stop)
    }
}
