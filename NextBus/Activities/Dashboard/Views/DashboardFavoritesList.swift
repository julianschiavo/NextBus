//
//  DashboardFavoritesList.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct DashboardFavoritesList: View {
    @EnvironmentObject private var store: Store
    
    var body: some View {
        if store.favorites.all.isEmpty {
            placeholder
        } else {
            list
        }
    }
    
    private var list: some View {
        LazyVStack(spacing: 0) {
            ForEach(store.favorites.all.prefix(3)) { favorite in
                DashboardRouteRow(routeStop: favorite)
                Divider()
            }
            AllFavoritesButton()
        }
        .background(Color.secondaryBackground)
    }
    
    private var placeholder: some View {
        Label("No Favorites", systemImage: "heart.fill")
            .font(.headline, weight: .semibold)
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.secondaryBackground)
    }
}
