//
//  LocationRequiredSheet.swift
//  NextBus
//
//  Created by Julian Schiavo on 28/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct LocationRequiredSheet: View {
    @EnvironmentObject private var locationTracker: LocationTracker
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 10) {
                icon
                title
                if locationTracker.hasRequestedPermission {
                    disabledError
                } else {
                    description
                }
            }
            .padding(10)
            if !locationTracker.hasRequestedPermission {
                button
            }
        }
        .padding(10)
        .background(.ultraThinMaterial)
        .roundedBorder(20)
        .padding(9)
    }
    
    private var icon: some View {
        Image(systemName: "location.fill.viewfinder")
            .font(.largeTitle, weight: .heavy)
    }
    
    private var title: some View {
        Text(Localizable.Directions.locationRequiredTitle)
            .font(.title3, weight: .bold)
            .multilineTextAlignment(.center)
    }
    
    private var description: some View {
        Text(Localizable.Directions.locationRequiredDescription)
            .font(.headline, weight: .regular)
            .multilineTextAlignment(.center)
    }
    
    private var disabledError: some View {
        Text(Localizable.Directions.locationRequiredError)
            .font(.headline, weight: .regular)
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
    }
    
    private var button: some View {
        Button {
            locationTracker.requestPermission()
        } label: {
            Text(Localizable.Directions.enable)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
        .controlProminence(.increased)
        .macCustomButton()
    }
}
