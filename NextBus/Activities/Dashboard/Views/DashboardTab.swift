//
//  DashboardTab.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct DashboardTab: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    favoritesCard
                    recentlyViewedCard
                }
                .padding(.horizontal, 12)
                .padding(.top, 10)
                .padding(.bottom, 15)
            }
            .navigationTitle("Dashboard")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var favoritesCard: some View {
        Card("Favorites", systemImage: "heart.fill") {
            DashboardFavoritesList()
        }
    }
    
    private var recentlyViewedCard: some View {
        Card("Recently Viewed", systemImage: "clock.arrow.circlepath") {
            DashboardRecentlyViewedList()
        }
    }
}
