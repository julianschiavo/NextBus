//
//  Main.swift
//  NextBus
//
//  Created by Julian Schiavo on 12/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct Main: View {
    @ObservedObject private var store = Store.shared
    
    var body: some View {
        ScrollView {
            NavigationLink(destination: RoutesList()) {
                Label(Localizable.Routes.name, systemImage: "bus.doubledecker.fill")
                    .alignedHorizontally(to: .leading)
            }
            .foregroundColor(.yellow)
            
            NavigationLink(destination: FavoritesList()) {
                Label(Localizable.Dashboard.favorites, systemImage: "heart.fill")
                    .alignedHorizontally(to: .leading)
            }
            .foregroundColor(.red)
            
            NavigationLink(destination: RecentsList()) {
                Label(Localizable.Dashboard.recents, systemImage: "clock.arrow.circlepath")
                    .alignedHorizontally(to: .leading)
            }
            .foregroundColor(.blue)
        }
        .navigationTitle(Localizable.appName)
    }
}
