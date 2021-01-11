//
//  AllFavoritesButton.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct AllFavoritesButton: View {
    var body: some View {
        NavigationLink(destination: FavoritesList()) {
            HStack {
                Label("All Favorites", systemImage: "heart.fill")
                Spacer()
                chevron
            }
//            .alignedHorizontally(to: .leading)
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity)
            .background(Color.tertiaryBackground)
        }
    }
    
    private var chevron: some View {
        Image(systemName: "chevron.right")
            .font(.callout, weight: .semibold)
            .foregroundColor(.secondary)
    }
}
