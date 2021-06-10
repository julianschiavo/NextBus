//
//  WalkingDirectionsButton.swift
//  NextBus
//
//  Created by Julian Schiavo on 11/2/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import MapKit
import SwiftUI

struct WalkingDirectionsButton: View {
    let track: RoutingTrack
    
    var body: some View {
        Button(action: openInMaps) {
            Label(Localizable.Directions.openWalkingDirections, systemImage: "figure.walk")
                .alignedHorizontally(to: .leading)
                .iOSPadding(.vertical, 10)
                .iOSPadding(.horizontal, 12)
                .iOSBackground(Color.tertiaryBackground)
                .macPadding(.vertical, 8)
                .macPadding(.horizontal, 8)
                .roundedBorder(10)
        }
        .macCustomButton()
    }
    
    private func openInMaps() {
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        MKMapItem.openMaps(with: [track.origin.mapItem, track.destination.mapItem], launchOptions: launchOptions)
    }
}
