//
//  StopDetailHeader.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct StopDetailHeader: View {
    let route: Route
    let stop: Stop
    
    var body: some View {
        HStack(spacing: 15) {
            icon
            info
        }
        .alignedHorizontally(to: .leading)
    }
    
    private var icon: some View {
        route.company.category.image
            .font(.largeTitle, weight: .black)
            .foregroundColor(route.company.color)
    }
    
    private var info: some View {
        VStack(alignment: .leading, spacing: 4) {
            title
            description
        }
    }
    
    private var title: some View {
        Text(Localizable.routeName(route.localizedName))
            .font(.title)
            .fontWeight(.heavy)
    }
    
    private var description: some View {
        VStack(alignment: .labelText, spacing: 4) {
            origin
            destination
        }
        .labelStyle(AlignedTextLabelStyle())
        .foregroundColor(.secondary)
        .lineLimit(3)
    }
    
    private var origin: some View {
        Label(stop.localizedName, systemImage: "figure.walk")
    }
    
    private var destination: some View {
        Label(route.localizedDestination, systemImage: "mappin.and.ellipse")
    }
}
