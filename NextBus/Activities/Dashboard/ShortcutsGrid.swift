//
//  ShortcutsGrid.swift
//  NextBus
//
//  Created by Julian Schiavo on 23/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct ShortcutsGrid: View {
    @Binding var currentTab: Int
    
    private let gridItem = GridItem(.flexible())
    
    var body: some View {
        LazyVGrid(columns: [gridItem, gridItem], alignment: .labelText) {
            favorites
            routes
            directions
            schedule
        }
        .macCustomButton()
        .labelStyle(AlignedTextLabelStyle())
    }
    
    private var favorites: some View {
        NavigationLink(destination: FavoritesList()) {
            Label(Localizable.Dashboard.favorites, systemImage: "heart.fill")
                .font(.largeHeadline, weight: .bold)
                .foregroundColor(.primary)
                .alignedHorizontally(to: .leading)
                .padding(4)
                .iOSPadding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red.opacity(0.8))
                .roundedBorder(10)
        }
    }
    
    private var routes: some View {
        Button {
            withAnimation {
                currentTab = 3
            }
        } label: {
            Label(Localizable.Routes.name, image: "bus.doubledecker.hk.fill")
                .font(.largeHeadline, weight: .bold)
                .foregroundColor(.primary)
                .alignedHorizontally(to: .leading)
                .padding(4)
                .iOSPadding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue.opacity(0.8))
                .roundedBorder(10)
        }
    }
    
    private var directions: some View {
        Button {
            withAnimation {
                currentTab = 2
            }
        } label: {
            Label(Localizable.Directions.name, systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                .font(.largeHeadline, weight: .bold)
                .foregroundColor(.primary)
                .alignedHorizontally(to: .leading)
                .padding(4)
                .iOSPadding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.green.opacity(0.8))
                .roundedBorder(10)
        }
    }
    
    private var schedule: some View {
        Button {
            withAnimation {
                currentTab = 4
            }
        } label: {
            Label(Localizable.Schedule.name, systemImage: "calendar")
                .font(.largeHeadline, weight: .bold)
                .foregroundColor(.primary)
                .alignedHorizontally(to: .leading)
                .padding(4)
                .iOSPadding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.8))
                .roundedBorder(10)
        }
    }
}
