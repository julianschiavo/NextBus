//
//  InvocatedStatusExperience.swift
//  Clip
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Loadability
import SwiftUI

struct InvocatedStatusExperience: View, LoadableView {
    @Environment(\.dismiss) private var dismiss
    
    let company: Company
    let routeID: String
    let stopID: String?
    
    @StateObject var loader = RoutesLoader()
    
    var body: some View {
        loaderView
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(Localizable.done) {
                        dismiss()
                    }
                }
            }
    }
    
    @ViewBuilder func body(with companyRoutes: [CompanyRoutes]) -> some View {
        if let routes = loader.routes, let route = route(from: routes) {
            if let stopID = stopID {
                InvocatedStatusExperienceStop(route: route, stopID: stopID)
            } else {
                BusDetail(route: route, navigationTitle: Localizable.appName)
            }
        } else {
            InvocationError()
        }
    }
    
    private func route(from routes: [Route]) -> Route? {
        routes.first { $0.company == company && $0.id == routeID }
    }
    
    func placeholder() -> some View {
        ProgressView(Localizable.loadingRoute)
    }
}

private struct InvocatedStatusExperienceStop: View, LoadableView {
    let route: Route
    let stopID: String
    
    @StateObject var loader = RouteStopsLoader()
    
    var key: Route { route }
    
    var body: some View {
        loaderView
    }
    
    @ViewBuilder func body(with stops: [Stop]) -> some View {
        if let stop = self.stop(from: stops) {
            StopDetail(route: route, stop: stop, navigationTitle: Localizable.appName)
        } else {
            InvocationError()
        }
    }
    
    private func stop(from stops: [Stop]) -> Stop? {
        stops.first { $0.id == stopID }
    }
    
    func placeholder() -> some View {
        ProgressView(Localizable.loadingStop)
    }
}
