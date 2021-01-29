//
//  RouteArrivalRow.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct RouteArrivalRow<Menu: View>: View {
    @EnvironmentObject private var store: Store
    
    let routeStop: RouteStop
    let extraMenu: Menu
    
    @State private var sheet: Sheet?
    
    init(routeStop: RouteStop, @ViewBuilder extraMenu: () -> Menu) {
        self.routeStop = routeStop
        self.extraMenu = extraMenu()
    }
    
    var body: some View {
        NavigationLink(destination: StopDetail(route: routeStop.route, stop: routeStop.stop)) {
            HStack(alignment: .top, spacing: 12) {
                name
                info
                Spacer()
                chevron
            }
        }
        .macCustomButton()
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.secondaryBackground)
        .cornerRadius(10)
        .contextMenu {
            menu
        }
        .globalSheet($sheet)
    }
    
    @ViewBuilder private var menu: some View {
        FavoritesButton(route: routeStop.route, stop: routeStop.stop)
        if store.recents.contains(routeStop) {
            RemoveRecentButton(route: routeStop.route, stop: routeStop.stop)
        }
        ShareButton($sheet, route: routeStop.route, stop: routeStop.stop)
        extraMenu
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

extension RouteArrivalRow where Menu == EmptyView {
    init(routeStop: RouteStop) {
        self.routeStop = routeStop
        self.extraMenu = EmptyView()
    }
}
