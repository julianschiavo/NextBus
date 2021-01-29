//
//  DashboardRecentlyViewedList.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct DashboardRecentsList: View {
    @EnvironmentObject private var store: Store
    
    var body: some View {
        if store.recents.all.isEmpty {
            placeholder
        } else {
            list
        }
    }
    
    private var list: some View {
        LazyVStack(spacing: 0) {
            ForEach(store.recents.all) { routeStop in
                RouteArrivalRow(routeStop: routeStop)
                Divider()
            }
        }
        .background(Color.secondaryBackground)
    }
    
    private var placeholder: some View {
        Label("No Recents", systemImage: "clock.arrow.circlepath")
            .font(.headline, weight: .semibold)
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.secondaryBackground)
    }
}
