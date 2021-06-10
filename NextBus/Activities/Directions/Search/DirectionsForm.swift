//
//  DirectionsForm.swift
//  NextBus
//
//  Created by Julian Schiavo on 23/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import MapKit
import SwiftUI

struct DirectionsForm: View {
    @EnvironmentObject private var locationTracker: LocationTracker
    
    @Binding var origin: Waypoint?
    @Binding var destination: Waypoint?
    let calculate: () -> Void
    
    @State private var originMapItem: MKMapItem?
    @State private var destinationMapItem: MKMapItem?
    
    var body: some View {
        VStack {
            originTextField
            destinationTextField
            Spacer().frame(height: 10)
            button
        }
        .padding(10)
        .background(Color.secondaryBackground)
        .overlay(disabledOverlay)
        .roundedBorder(20)
        .padding(8)
        .disabled(!locationTracker.hasPermission)
    }
    
    private var originTextField: some View {
        LocationSearchBar(mapItem: $originMapItem, placeholder: Localizable.fromPlaceholder)
            .background(Color.tertiaryBackground)
            .roundedBorder(10)
            .onChange(of: originMapItem) { mapItem in
                guard let mapItem = mapItem else { return }
                origin = Waypoint(id: UUID().uuidString, index: 0, name: mapItem.name ?? "", latitude: mapItem.placemark.coordinate.latitude, longitude: mapItem.placemark.coordinate.longitude, mapItem: mapItem)
            }
    }
    
    private var destinationTextField: some View {
        LocationSearchBar(mapItem: $destinationMapItem, placeholder: Localizable.toPlaceholder, onSearch: calculate)
            .background(Color.tertiaryBackground)
            .roundedBorder(10)
            .onChange(of: destinationMapItem) { mapItem in
                guard let mapItem = mapItem else { return }
                destination = Waypoint(id: UUID().uuidString, index: 0, name: mapItem.name ?? "", latitude: mapItem.placemark.coordinate.latitude, longitude: mapItem.placemark.coordinate.longitude, mapItem: mapItem)
            }
    }
    
    private var button: some View {
        Button(action: calculate) {
            Text(Localizable.Directions.go)
                .font(.headline, weight: .bold)
                .foregroundColor(.primary)
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color.accent)
                .cornerRadius(10)
        }
        .disabled(origin == nil || destination == nil)
        .macCustomButton()
    }
    
    @ViewBuilder private var disabledOverlay: some View {
        if !locationTracker.hasPermission {
            Color.gray.opacity(0.4)
        }
    }
}
