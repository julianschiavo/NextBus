//
//  FavoritesTab.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct FavoritesTab: View {
    var body: some View {
        NavigationView {
            FavoritesList()
                .navigationTitle("Favorites")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
