//
//  Main.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct Main: View {
    @State private var currentTab = 1
    
    var body: some View {
        TabView(selection: $currentTab) {
            DashboardTab(currentTab: $currentTab)
                .tag(1)
                .tabItem {
                    Image(systemName: "rectangle.grid.2x2.fill")
                    Text(Localizable.Dashboard.name)
                }
            DirectionsTab()
                .tag(2)
                .tabItem {
                    Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                    Text(Localizable.Directions.name)
                }
            RoutesTab()
                .tag(3)
                .tabItem {
                    Image(systemName: "bus.fill")
                    Text(Localizable.Routes.name)
                }
            ScheduleTab()
                .tag(4)
                .tabItem {
                    Image(systemName: "calendar")
                    Text(Localizable.Schedule.name)
                }
        }
    }
}
