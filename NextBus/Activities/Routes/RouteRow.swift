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
    
    @State private var sheet: Sheet?
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            name
            info
        }
        .globalSheet($sheet)
        .contextMenu {
            ShareButton($sheet, route: route)
        }
    }
    
    private var name: some View {
        Text(route.localizedName)
            .font(.title3, weight: .bold)
            .foregroundColor(route.company.textColor)
            .padding(6)
            .background(route.company.color)
            .cornerRadius(12)
    }
    
    private var info: some View {
        VStack(alignment: .leading) {
            Text(route.localizedOrigin)
            Text("to " + route.localizedDestination)
                .font(.callout, weight: .semibold)
        }
        .lineLimit(1)
        .font(.callout)
        .foregroundColor(.secondary)
    }
}
