//
//  RouteETARow.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct RouteETARow: View {
    let routeStop: RouteStop
    
    @State private var sheet: Sheet?
    
    var body: some View {
        NavigationLink(destination: StopDetail(route: routeStop.route, stop: routeStop.stop)) {
            HStack(alignment: .top, spacing: 12) {
                name
                info
            }
        }
        .contextMenu {
            ShareButton($sheet, route: routeStop.route, stop: routeStop.stop)
            FavoritesButton(route: routeStop.route, stop: routeStop.stop)
        }
        .globalSheet($sheet)
    }
    
    private var name: some View {
        Text(routeStop.route.localizedName)
            .font(.title3, weight: .bold)
            .foregroundColor(routeStop.route.company.textColor)
            .padding(6)
            .background(routeStop.route.company.color)
            .cornerRadius(12)
    }
    
    private var info: some View {
        VStack(alignment: .leading) {
            if routeStop.companyID.supportsETA {
                ETALabel(route: routeStop.route, stop: routeStop.stop)
            }
            Text(routeStop.stop.localizedName)
                .font(.callout)
                .foregroundColor(.secondary)
            Text(Localizable.to(routeStop.route.localizedDestination))
                .font(.callout)
                .foregroundColor(.secondary)
        }
        .lineLimit(1)
    }
}
