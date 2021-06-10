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
                .iOSPadding(.vertical, 10)
                .iOSPadding(.horizontal, 12)
                .iOSBackground(Color.quaternaryBackground)
                .macPadding(.vertical, 8)
                .macPadding(.horizontal, 8)
        }
        .macCustomButton()
        .onChange(of: store.favorites.all) { _ in }
    }
    
    @ViewBuilder private func label() -> some View {
        if store.favorites.contains(route: route, stop: stop) {
            Text(Localizable.removeFavorite)
        } else {
            Text(Localizable.addToFavorites)
        }
    }
    
    @ViewBuilder private func icon() -> some View {
        if store.favorites.contains(route: route, stop: stop) {
            Image(systemName: "heart.slash.fill")
        } else {
            Image(systemName: "heart")
        }
    }
    
    private func add() {
        if store.favorites.contains(route: route, stop: stop) {
            store.favorites.set(false, route: route, stop: stop)
        } else {
            store.favorites.set(true, route: route, stop: stop)
        }
    }
}
