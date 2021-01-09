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
        if store.favorites.isEmpty {
            placeholder
        } else {
            list
        }
    }
    
    private var list: some View {
        List(store.favorites) { favorite in
            FavoriteRow(favorite: favorite)
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    private var placeholder: some View {
        VStack(spacing: 15) {
            Image(systemName: "heart.fill")
                .font(.title, weight: .heavy)
            Text("No Favorites")
                .font(.title, weight: .bold)
        }
    }
}
