//
//  DashboardTab.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct DashboardTab: View {
    @Binding var currentTab: Int
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    ShortcutsGrid(currentTab: $currentTab)
                    #if os(iOS)
                    AddToSiriCard()
                    #endif
                    CurrentScheduleCard()
                    favoritesCard
                    recentsCard
                }
                .padding(.horizontal, 12)
                .padding(.top, 10)
                .padding(.bottom, 15)
            }
            .macMinFrame(width: 260)
            .navigationTitle("Dashboard")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var favoritesCard: some View {
        Card("Favorites", systemImage: "heart.fill") {
            DashboardFavoritesList()
        }
    }
    
    private var recentsCard: some View {
        Card("Recents", systemImage: "clock.arrow.circlepath") {
            DashboardRecentsList()
        }
    }
}
