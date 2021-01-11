//
//  InvocatedExperience.swift
//  Clip
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct InvocatedExperience: View, Loadable {
    let companyID: CompanyID
    let routeID: String
    let stopID: String?
    
    @StateObject var loader = RoutesLoader()
    
    var body: some View {
        loaderView
    }
    
    @ViewBuilder func body(with routes: [CompanyRoutes]) -> some View {
        if let route = route(from: routes), let stopID = stopID {
            InvocatedExperienceStop(route: route, stopID: stopID)
        } else if let route = route(from: routes) {
            BusDetail(route: route)
        } else {
            InvocationError()
        }
    }
    
    private func route(from routes: [CompanyRoutes]) -> Route? {
        guard let companyRoutes = routes.first(where: { $0.company == companyID }),
              let route = companyRoutes.routes.first(where: { $0.id == routeID })
        else { return nil }
        return route
    }
    
    func placeholder() -> some View {
        ProgressView("Loading Route...")
    }
}

private struct InvocatedExperienceStop: View, Loadable {
    let route: Route
    let stopID: String
    
    @StateObject var loader = StopsLoader()
    
    var key: Route { route }
    
    var body: some View {
        loaderView
    }
    
    @ViewBuilder func body(with stops: [Stop]) -> some View {
        if let stop = stop(from: stops) {
            StopDetail(route: route, stop: stop)
                .navigationTitle("Next Bus")
        } else {
            InvocationError()
        }
    }
    
    private func stop(from stops: [Stop]) -> Stop? {
        stops.first { $0.id == stopID }
    }
    
    func placeholder() -> some View {
        ProgressView("Loading Stop...")
    }
}
