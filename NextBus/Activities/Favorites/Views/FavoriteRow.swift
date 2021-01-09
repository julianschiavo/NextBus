//
//  FavoriteRow.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct FavoriteRow: View {
    let favorite: Favorite
    
    var body: some View {
        NavigationLink(destination: StopDetail(route: favorite.route, stop: favorite.stop)) {
            HStack {
                name
                info
                NextBusLabel(route: favorite.route, stop: favorite.stop)
            }
        }
    }
    
    private var name: some View {
        Text(favorite.route.localizedName)
            .font(.title2, weight: .bold)
            .foregroundColor(favorite.route.companyID.textColor)
            .padding(7)
            .background(favorite.route.companyID.color)
            .cornerRadius(12)
    }
    
    private var info: some View {
        VStack(alignment: .leading) {
            Text(favorite.route.localizedOrigin)
            Text("to " + favorite.route.localizedDestination)
        }
        .lineLimit(1)
        .font(.footnote)
        .foregroundColor(.secondary)
    }
}
