//
//  FavoriteRow.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct FavoriteRow: View {
    let favorite: RouteStop
    
    @State private var isShareSheetPresented = false
    
    var body: some View {
        NavigationLink(destination: StopDetail(route: favorite.route, stop: favorite.stop)) {
            HStack(alignment: .top, spacing: 12) {
                name
                info
            }
        }
        .sheet(isPresented: $isShareSheetPresented) {
            RouteShareSheet(route: favorite.route, stop: favorite.stop)
        }
        .contextMenu {
            FavoritesButton(route: favorite.route, stop: favorite.stop)
            ShareButton(isPresented: $isShareSheetPresented)
        }
    }
    
    private var name: some View {
        Text(favorite.route.localizedName)
            .font(.title3, weight: .bold)
            .foregroundColor(favorite.route.companyID.textColor)
            .padding(6)
            .background(favorite.route.companyID.color)
            .cornerRadius(12)
    }
    
    private var info: some View {
        VStack(alignment: .leading) {
            if favorite.companyID.supportsETA {
                ETALabel(route: favorite.route, stop: favorite.stop)
            }
            Text(favorite.route.localizedOrigin)
                .font(.callout)
                .foregroundColor(.secondary)
            Text("to " + favorite.route.localizedDestination)
                .font(.callout)
                .foregroundColor(.secondary)
        }
        .lineLimit(1)
    }
}
