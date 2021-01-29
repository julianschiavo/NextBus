//
//  FavoritesList.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct FavoritesList: View {
    @EnvironmentObject private var store: Store
    
    var body: some View {
        #if os(macOS)
        NavigationView {
            contents
                .macMinFrame(width: 260)
                .navigationTitle("Favorites")
        }
        #else
        contents
            .navigationTitle("Favorites")
            .navigationTitleDisplayMode(.inline)
        #endif
    }
    
    @ViewBuilder var contents: some View {
        if store.favorites.all.isEmpty {
            placeholder
        } else {
            list
        }
    }
    
    private var list: some View {
        List(store.favorites.all) { favorite in
            RouteETARow(routeStop: favorite)
        }
        .listStyle(SidebarListStyle())
    }
    
    private var placeholder: some View {
        VStack(alignment: .center, spacing: 15) {
            Image(systemName: "heart.fill")
                .font(.title2, weight: .heavy)
            Text("No Favorites")
                .font(.title2, weight: .bold)
        }
    }
}
