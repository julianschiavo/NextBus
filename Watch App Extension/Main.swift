//
//  Main.swift
//  NextBus
//
//  Created by Julian Schiavo on 12/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct Main: View {
    @StateObject private var store = Store()
    
    var body: some View {
        VStack {
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
            .foregroundColor(.primary)
        }
        .navigationTitle(Localizable.appName)
    }
}
