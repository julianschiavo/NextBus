//
//  RouteRow.swift
//  NextBus
//
//  Created by Julian Schiavo on 12/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct RouteRow: View {
    let route: Route
    
    var body: some View {
        NavigationLink(destination: BusDetail(route: route)) {
            VStack(alignment: .leading, spacing: 2) {
                name
                info
            }
            .padding(.vertical, 2)
        }
    }
    
    private var name: some View {
        Text(route.localizedName)
            .font(.largeHeadline, weight: .bold)
            .foregroundColor(route.company.color)
    }
    
    private var info: some View {
        VStack(alignment: .leading) {
            Text(route.localizedOrigin)
                .font(.caption2)
            Text("to " + route.localizedDestination)
                .font(.caption2)
        }
        .lineLimit(1)
        .foregroundColor(.secondary)
    }
}
