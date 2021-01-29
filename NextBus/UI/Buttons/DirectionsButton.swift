//
//  DirectionsButton.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import MapKit
import SwiftUI

struct DirectionsButton: View {
    let name: String
    let latitude: Double
    let longitude: Double
    
    var body: some View {
        Button(action: openInMaps) {
            Label("Directions", systemImage: "figure.walk.circle.fill")
                .alignedHorizontally(to: .leading)
                .iOSPadding(.vertical, 10)
                .iOSPadding(.horizontal, 12)
                .iOSBackground(Color.tertiaryBackground)
                .macPadding(.vertical, 8)
                .macPadding(.horizontal, 8)
        }
        .macCustomButton()
    }
    
    private func openInMaps() {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
}
