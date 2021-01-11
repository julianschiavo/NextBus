//
//  DashboardRecentlyViewedList.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct DashboardRecentlyViewedList: View {
    @EnvironmentObject private var store: Store
    
    var body: some View {
        if store.recentlyViewed.all.isEmpty {
            placeholder
        } else {
            list
        }
    }
    
    private var list: some View {
        LazyVStack(spacing: 0) {
            ForEach(store.recentlyViewed.all) { routeStop in
                DashboardRouteRow(routeStop: routeStop)
                Divider()
            }
        }
        .background(Color.secondaryBackground)
    }
    
    private var placeholder: some View {
        Label("No Recently Viewed", systemImage: "clock.arrow.circlepath")
            .font(.headline, weight: .semibold)
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.secondaryBackground)
    }
}
