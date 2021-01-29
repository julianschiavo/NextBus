//
//  DirectionsView.swift
//  NextBus
//
//  Created by Julian Schiavo on 28/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import MapKit
import SwiftUI

struct DirectionsView: View {
    enum Phase {
        case search
        case selectTrack
        case instructions
    }
    
    @EnvironmentObject private var locationTracker: LocationTracker
    
    @Binding var sheet: Sheet?
    
    @State private var state = Phase.search
    
    @State private var origin: MKMapItem?
    @State private var destination: MKMapItem?
    
    @State private var annotations = [MKAnnotation]()
    
    @State private var directions: Directions?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            DirectionsMap(annotations: $annotations, directions: $directions)
            card
            cancelButton
        }
        .onChange(of: origin, perform: updateAnnotations)
        .onChange(of: destination, perform: updateAnnotations)
        .onChange(of: directions) { directions in
            guard directions != nil else { return }
            withAnimation {
                state = .instructions
            }
        }
    }
    
    @ViewBuilder private var card: some View {
        switch state {
        case .search:
            form
        case .selectTrack:
            select
        case .instructions:
            instructions
        }
    }
    
    private var form: some View {
        VStack {
            if !locationTracker.hasPermission {
                LocationRequiredSheet()
            }
            DirectionsForm(origin: $origin, destination: $destination, calculate: selectTrack)
        }
    }
    
    private var select: some View {
        SelectRoutingCard {
            selectTrack()
        } onCancel: {
            reset()
        }
    }
    
    private var instructions: some View {
        Text("guuuuu")
//        DirectionsSheet(origin: $origin, destination: $destination)
    }
    
    @ViewBuilder private var cancelButton: some View {
        if state == .instructions {
            Button {
                reset()
            } label: {
                Image(systemName: "xmark")
                    .font(.largeHeadline, weight: .heavy)
                    .foregroundColor(.primary)
                    .padding(15)
                    .background(Color.quaternaryBackground.opacity(0.8))
                    .cornerRadius(15)
            }
            .macCustomButton()
            .aligned(to: .topTrailing)
            .padding(10)
        }
    }
    
    private func selectTrack() {
        guard let origin = origin, let destination = destination else { return }
        withAnimation {
            state = .selectTrack
            sheet = .pickDirections(origin: origin, destination: destination, selection: $directions)
        }
    }
    
    private func reset() {
        withAnimation {
            state = .search
            origin = nil
            destination = nil
            annotations = []
            directions = nil
        }
    }
    
    private func updateAnnotations(_ obj: MKMapItem? = nil) {
        withAnimation {
            annotations = [origin, destination]
                .compactMap { item -> MKPointAnnotation? in
                    guard let item = item else { return nil }
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = item.placemark.title
                    return annotation
                }
        }
    }
}
