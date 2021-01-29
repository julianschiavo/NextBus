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
        .background(Color.secondaryBackground)
        .roundedBorder(20)
        .padding(9)
    }
    
    private var icon: some View {
        Image(systemName: "location.fill.viewfinder")
            .font(.largeTitle, weight: .heavy)
    }
    
    private var title: some View {
        Text("Enable Location for Directions")
            .font(.title3, weight: .bold)
            .multilineTextAlignment(.center)
    }
    
    private var description: some View {
        Text("Get public transport directions around Hong Kong—wherever you are.")
            .font(.headline, weight: .regular)
            .multilineTextAlignment(.center)
    }
    
    private var disabledError: some View {
        Text("Location access has been disabled. Enable it in the Settings app.")
            .font(.headline, weight: .regular)
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
    }
    
    private var button: some View {
        Button {
            locationTracker.requestPermission()
        } label: {
            Text("Enable")
                .foregroundColor(.primary)
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color.accent)
                .cornerRadius(10)
        }
        .macCustomButton()
    }
}