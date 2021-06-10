//
//  BusDetailHeader.swift
//  NextBus
//
//  Created by Julian Schiavo on 6/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct BusDetailHeader: View {
    let route: Route
    
    var body: some View {
        HStack(spacing: 15) {
            icon
            info
        }
        .alignedHorizontally(to: .leading)
    }
    
    private var icon: some View {
        Image(systemName: route.company.category.iconName)
            .font(.largeTitle)
            .foregroundColor(route.company.color)
    }
    
    private var info: some View {
        VStack(alignment: .leading, spacing: 4) {
            title
            description
        }
    }
    
    private var description: some View {
        VStack(alignment: .labelText, spacing: 4) {
            origin
            destination
        }
    }
    
    private var title: some View {
        Text(Localizable.routeName(route.localizedName))
            .font(.title)
            .fontWeight(.heavy)
    }
    
    private var origin: some View {
        Label(route.localizedOrigin, systemImage: "figure.walk")
            .labelStyle(AlignedTextLabelStyle())
            .foregroundColor(.secondary)
            .lineLimit(2)
    }
    
    private var destination: some View {
        Label(route.localizedDestination, systemImage: "mappin.and.ellipse")
            .labelStyle(AlignedTextLabelStyle())
            .foregroundColor(.secondary)
            .lineLimit(2)
    }
}
