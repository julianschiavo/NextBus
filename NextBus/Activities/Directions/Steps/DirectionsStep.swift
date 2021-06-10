//
//  DirectionsStep.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/2/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct DirectionsStep: View {
    let track: RoutingTrack
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 15) {
                name
                info
            }
            if track.isWalking {
                WalkingDirectionsButton(track: track)
            }
        }
        .padding(10)
    }
    
    @ViewBuilder private var name: some View {
        if track.isWalking {
            Image(systemName: "figure.walk")
                .font(.title3, weight: .bold)
        } else if let company = track.company {
            HStack(spacing: 4) {
                Image(systemName: company.category.iconName)
                Text(track.name.isEmpty ? company.name : track.name)
            }
            .font(.title3, weight: .bold)
            .foregroundColor(company.textColor)
            .padding(6)
            .background(company.color)
            .cornerRadius(12)
        }
    }
    
    @ViewBuilder private var info: some View {
        if track.isWalking {
            infoLabel(title: Localizable.Directions.walkTo(track.destination.name))
        } else {
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
    }
    
    private func infoLabel(title: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title3, weight: .heavy)
            if track.isWalking {
                Text(Localizable.from(track.origin.name))
                    .font(.headline, weight: .regular)
                    .foregroundColor(.secondary)
            } else {
                Text(Localizable.to(track.destination.name))
                    .font(.headline, weight: .regular)
                    .foregroundColor(.secondary)
            }
        }
        .lineLimit(3)
        .alignedHorizontally(to: .leading)
    }
}
