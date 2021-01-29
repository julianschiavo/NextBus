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
    
    @Binding var origin: MKMapItem?
    @Binding var destination: MKMapItem?
    let calculate: () -> Void
    
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
        LocationSearchBar(mapItem: $origin, placeholder: "From")
            .background(Color.tertiaryBackground)
            .roundedBorder(10)
    }
    
    private var destinationTextField: some View {
        LocationSearchBar(mapItem: $destination, placeholder: "To", onSearch: calculate)
            .background(Color.tertiaryBackground)
            .roundedBorder(10)
    }
    
    private var button: some View {
        Button(action: calculate) {
            Text("Go")
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
