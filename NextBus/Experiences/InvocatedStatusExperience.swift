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
    @Environment(\.presentationMode) var presentationMode
    
    let experience: StatusExperience
    
    @StateObject var loader = RoutesLoader()
    
    var body: some View {
        loaderView
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(Localizable.done) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
    }
    
    @ViewBuilder func body(with companyRoutes: [CompanyRoutes]) -> some View {
        if let routes = loader.routes, let route = route(from: routes) {
            if experience.stopID != nil {
                InvocatedStatusExperienceStop(experience: experience, route: route)
            } else {
                BusDetail(route: route, navigationTitle: Localizable.appName)
            }
        } else {
            InvocationError()
        }
    }
    
    private func route(from routes: [Route]) -> Route? {
        routes.first { $0.company == experience.company && $0.id == experience.routeID }
    }
    
    func placeholder() -> some View {
        ProgressView(Localizable.loadingRoute)
    }
}

private struct InvocatedStatusExperienceStop: View, LoadableView {
    let experience: StatusExperience
    let route: Route
    
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
        stops.first { $0.id == experience.stopID }
    }
    
    func placeholder() -> some View {
        ProgressView(Localizable.loadingStop)
    }
}
