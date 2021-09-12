//
//  CurrentLocationButton.swift
//  NextBus
//
//  Created by Julian Schiavo on 11/2/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import MapKit
import SwiftUI

struct CurrentLocationButton: View {
    @EnvironmentObject private var locationTracker: LocationTracker
    @Binding var searchText: String
    @Binding var mapItem: MKMapItem?
    
    var body: some View {
        Button {
            let clLocation = locationTracker.location
            let placemark = MKPlacemark(coordinate: clLocation.coordinate)
            mapItem = MKMapItem(placemark: placemark)
            mapItem?.name = Localizable.Directions.currentLocation
            searchText = Localizable.Directions.currentLocation
        } label: {
            Image(systemName: "location.fill")
                .foregroundColor(.red)
                .padding(5)
                .background(Color.background.opacity(0.001))
        }
        .macCustomButton()
    }
}
