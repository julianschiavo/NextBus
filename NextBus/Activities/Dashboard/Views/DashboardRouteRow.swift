//
//  DashboardRouteRow.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct DashboardRouteRow: View {
    @EnvironmentObject private var store: Store
    
    let routeStop: RouteStop
    
    @State private var isShareSheetPresented = false
    
    var body: some View {
        NavigationLink(destination: StopDetail(route: routeStop.route, stop: routeStop.stop)) {
            HStack(alignment: .top, spacing: 12) {
                name
                info
                Spacer()
                chevron
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.secondaryBackground)
        .cornerRadius(10)
        .contextMenu {
            menu
        }
        .sheet(isPresented: $isShareSheetPresented) {
            RouteShareSheet(route: routeStop.route, stop: routeStop.stop)
        }
    }
    
    @ViewBuilder private var menu: some View {
        FavoritesButton(route: routeStop.route, stop: routeStop.stop)
        if store.recentlyViewed.contains(routeStop) {
            RemoveRecentlyViewedButton(route: routeStop.route, stop: routeStop.stop)
        }
        ShareButton(isPresented: $isShareSheetPresented)
    }
    
    private var name: some View {
        Text(routeStop.route.localizedName)
            .font(.title3, weight: .bold)
            .foregroundColor(routeStop.route.companyID.textColor)
            .padding(6)
            .background(routeStop.route.companyID.color)
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
            Text("to " + routeStop.route.localizedDestination)
                .font(.callout)
                .foregroundColor(.secondary)
        }
        .lineLimit(1)
    }
    
    private var chevron: some View {
        Image(systemName: "chevron.right")
            .font(.callout, weight: .semibold)
            .foregroundColor(.secondary)
    }
}
