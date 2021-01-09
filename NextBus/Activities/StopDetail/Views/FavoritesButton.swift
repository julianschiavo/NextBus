//
//  FavoritesButton.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct FavoritesButton: View {
    @EnvironmentObject private var store: Store
    
    let route: Route
    let stop: Stop
    
    var body: some View {
        Button(action: add) {
            Label(title: label, icon: icon)
                .alignedHorizontally(to: .leading)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(Color.quaternaryBackground)
        }
        .onChange(of: store.favorites) { _ in }
    }
    
    @ViewBuilder private func label() -> some View {
        if store.isFavorite(route: route, stop: stop) {
            Text("Remove Favorite")
        } else {
            Text("Add to Favorites")
        }
    }
    
    @ViewBuilder private func icon() -> some View {
        if store.isFavorite(route: route, stop: stop) {
            Image(systemName: "heart.fill")
        } else {
            Image(systemName: "heart")
        }
    }
    
    private func add() {
        if store.isFavorite(route: route, stop: stop) {
            store.setFavorite(false, favorite: Favorite(route: route, stop: stop))
        } else {
            store.setFavorite(true, favorite: Favorite(route: route, stop: stop))
        }
    }
}
