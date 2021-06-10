//
//  DirectionsStepsPager.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/2/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import MapKit
import SwiftUI

struct DirectionsStepsPager: View {
    
    @Binding var focusedTrack: RoutingTrack?
    let routing: Routing
    let origin: Waypoint
    let destination: Waypoint
    let changeRouting: () -> Void
    
    @State private var selectedTrack = RoutingTrack.between(Waypoint(id: "", index: 0, name: "", latitude: 0, longitude: 0), and: Waypoint(id: "", index: 0, name: "", latitude: 0, longitude: 0), index: 0)
    
    init?(routing: Routing, origin: Waypoint, destination: Waypoint, focusedTrack: Binding<RoutingTrack?>, changeRouting: @escaping () -> Void) {
        self.routing = routing
        self.origin = origin
        self.destination = destination
        self._focusedTrack = focusedTrack
        self.changeRouting = changeRouting
    }
    
    var body: some View {
        VStack(spacing: 5) {
            Spacer()
                .layoutPriority(1)
            pager
                .padding(10)
                .background(Color.secondaryBackground)
                .roundedBorder(20)
            changeRoutingButton
        }
        .padding(8)
    }
    
    private var pager: some View {
        TabView(selection: $selectedTrack) {
            ForEach(routing.tracks) { track in
                VStack {
                    DirectionsStep(track: track)
                    #if os(iOS)
                    Spacer()
                        .frame(minHeight: 50)
                    #endif
                }
                .tag(track)
                .tabItem {
                    Text(track.name)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .onChange(of: selectedTrack) { track in
            focusedTrack = track
        }
    }
    
    private var changeRoutingButton: some View {
        Button(action: changeRouting) {
            Label(Localizable.Directions.changeRouting, systemImage: "chevron.left")
                .font(.headline, weight: .semibold)
                .foregroundColor(.primary)
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(Color.secondaryBackground)
                .roundedBorder(12)
        }
        .macCustomButton()
    }
}
