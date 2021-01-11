//
//  Main.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct Main: View {
    @StateObject private var store = Store()
    
    var body: some View {
        TabView {
            DashboardTab()
                .tabItem {
                    Label("Dashboard", systemImage: "star.fill")
                }
            RoutesTab()
                .tabItem {
                    Label("Routes", systemImage: "bus.fill")
                }
        }.environmentObject(store)
    }
}
