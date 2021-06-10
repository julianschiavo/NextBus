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
                Label(Localizable.Dashboard.allFavorites, systemImage: "heart.fill")
                #if os(iOS)
                Spacer()
                chevron
                #endif
            }
//            .alignedHorizontally(to: .leading)
            .iOSPadding(.vertical, 10)
            .iOSPadding(.horizontal, 12)
            .frame(maxWidth: .infinity)
            .iOSBackground(Color.tertiaryBackground)
            .macPadding(.vertical, 8)
            .macPadding(.horizontal, 8)
        }
        .macCustomButton()
    }
    
    private var chevron: some View {
        Image(systemName: "chevron.right")
            .font(.callout, weight: .semibold)
            .foregroundColor(.secondary)
    }
}
