//
//  RoutingTrackRow.swift
//  NextBus
//
//  Created by Julian Schiavo on 28/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct RoutingTrackRow: View {
    let track: RoutingTrack
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            name
            info
        }
        .padding(.vertical, 10)
    }
    
    @ViewBuilder private var name: some View {
        if let company = track.company {
            HStack(spacing: 4) {
                Image(systemName: company.category.iconName)
                Text(track.name.isEmpty ? company.name : track.name)
            }
            .font(.callout, weight: .bold)
            .foregroundColor(company.textColor)
            .padding(5)
            .background(company.color)
            .cornerRadius(12)
        }
    }
    
    @ViewBuilder private var info: some View {
        switch (track.company?.category ?? .bus) {
        case .bus, .minibus:
            infoLabel(title: Localizable.Directions.takeTheBus(track.name))
        case .ferry:
            infoLabel(title: Localizable.Directions.takeTheFerry)
        case .train:
            infoLabel(title: Localizable.Directions.rideOnTrain(track.name))
        case .tram:
            infoLabel(title: Localizable.Directions.takeTheTram)
        }
    }
    
    private func infoLabel(title: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline, weight: .bold)
            Text(Localizable.from(track.origin.name))
                .font(.callout)
                .foregroundColor(.secondary)
            Text(Localizable.from(track.destination.name))
                .font(.callout, weight: .semibold)
                .foregroundColor(.secondary)
        }
    }
}
