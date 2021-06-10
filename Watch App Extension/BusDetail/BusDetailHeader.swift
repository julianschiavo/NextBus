//
//  BusDetailHeader.swift
//  NextBus
//
//  Created by Julian Schiavo on 12/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct BusDetailHeader: View {
    let route: Route
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            title
            description
        }
    }
    
    private var title: some View {
        Text(Localizable.routeName(route.localizedName))
            .font(.largeHeadline)
            .fontWeight(.heavy)
    }
    
    private var description: some View {
        VStack(alignment: .labelText, spacing: 2) {
            origin
            destination
        }
    }
    
    private var origin: some View {
        Label(route.localizedOrigin, systemImage: "figure.walk")
            .font(.caption)
            .labelStyle(AlignedTextLabelStyle())
            .foregroundColor(.secondary)
            .lineLimit(2)
    }
    
    private var destination: some View {
        Label(route.localizedDestination, systemImage: "mappin.and.ellipse")
            .font(.caption)
            .labelStyle(AlignedTextLabelStyle())
            .foregroundColor(.secondary)
            .lineLimit(2)
    }
}
