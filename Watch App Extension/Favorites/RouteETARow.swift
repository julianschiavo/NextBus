//
//  RouteETARow.swift
//  Watch App Extension
//
//  Created by Julian Schiavo on 12/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct RouteETARow: View {
    let routeStop: RouteStop
    
    var body: some View {
        NavigationLink(destination: StopDetail(route: routeStop.route, stop: routeStop.stop)) {
            VStack(alignment: .leading, spacing: 2) {
                name
                info
            }
            .padding(.vertical, 2)
        }
    }
    
    private var name: some View {
        Text(routeStop.route.localizedName)
            .font(.largeHeadline, weight: .bold)
            .foregroundColor(routeStop.route.company.color)
    }
    
    private var info: some View {
        VStack(alignment: .leading) {
            if routeStop.companyID.supportsETA {
                ETALabel(route: routeStop.route, stop: routeStop.stop)
            }
            Text(routeStop.route.localizedOrigin)
                .font(.callout)
                .foregroundColor(.secondary)
            Text(Localizable.to(routeStop.route.localizedDestination))
                .font(.callout)
                .foregroundColor(.secondary)
        }
        .lineLimit(1)
    }
}
