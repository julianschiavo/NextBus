//
//  Main.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct Main: View {
    @State private var currentTab = 2
    
    var body: some View {
        TabView(selection: $currentTab) {
            DashboardTab(currentTab: $currentTab)
                .tag(1)
                .tabItem {
                    Image(systemName: "rectangle.grid.2x2.fill")
                    Text("Dashboard")
                }
            DirectionsTab()
                .tag(2)
                .tabItem {
                    Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                    Text("Directions")
                }
            RoutesTab()
                .tag(3)
                .tabItem {
                    Image(systemName: "bus.fill")
                    Text("Routes")
                }
            ScheduleTab()
                .tag(4)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Schedule")
                }
        }
    }
}
