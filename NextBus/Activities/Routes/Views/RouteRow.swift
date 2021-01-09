//
//  RouteRow.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct RouteRow: View {
    let route: Route
    
    var body: some View {
        NavigationLink(destination: BusDetail(route: route, direction: .inbound)) {
            HStack {
                name
                info
            }
        }
    }
    
    private var name: some View {
        Text(route.localizedName)
            .font(.title2, weight: .bold)
            .foregroundColor(route.companyID.textColor)
            .padding(7)
            .background(route.companyID.color)
            .cornerRadius(12)
    }
    
    private var info: some View {
        VStack(alignment: .leading) {
            Text(route.localizedOrigin)
            Text("to " + route.localizedDestination)
        }
        .lineLimit(1)
        .font(.callout)
        .foregroundColor(.secondary)
    }
}
