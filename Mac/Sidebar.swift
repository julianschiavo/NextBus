//
//  Sidebar.swift
//  Mac
//
//  Created by Julian Schiavo on 25/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct Sidebar: View {

    @State private var current: Int? = 1
    
    var body: some View {
        List {
            NavigationLink(destination: DashboardTab(currentTab: Binding($current) ?? .constant(1)), tag: 1, selection: $current) {
                Label(Localizable.Dashboard.name, systemImage: "rectangle.grid.2x2.fill")
            }
            NavigationLink(destination: FavoritesList(), tag: 5, selection: $current) {
                Label(Localizable.Dashboard.favorites, systemImage: "heart.fill")
            }
            NavigationLink(destination: DirectionsTab(), tag: 2, selection: $current) {
                Label(Localizable.Directions.name, systemImage: "arrow.triangle.turn.up.right.diamond.fill")
            }
            NavigationLink(destination: RoutesTab(), tag: 3, selection: $current) {
                Label(Localizable.Routes.name, image: "bus.doubledecker.hk.fill")
            }
            NavigationLink(destination: ScheduleTab(), tag: 4, selection: $current) {
                Label(Localizable.Schedule.name, systemImage: "calendar")
            }
        }
        .frame(minWidth: 100)
        .listStyle(.sidebar)
    }
}
