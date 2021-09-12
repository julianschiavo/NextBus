//
//  DirectionsView.swift
//  NextBus
//
//  Created by Julian Schiavo on 28/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

#if canImport(BottomSheet)
import BottomSheet
#endif
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
    
    @State private var origin: Waypoint?
    @State private var destination: Waypoint?
    
    @State private var annotations = [MKAnnotation]()
    @State private var paths = [RoutingPath]()
    @State private var focusedTrack: RoutingTrack?
    
    @State private var routing: Routing?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            DirectionsMap(annotations: $annotations, routing: $routing, focusedTrack: $focusedTrack, paths: $paths)
            card
                .macFrame(width: 350)
                .iOSMaxFrame(width: .infinity)
                .alignedHorizontally(to: .trailing)
            cancelButton
        }
        .onChange(of: origin, perform: updateAnnotations)
        .onChange(of: destination, perform: updateAnnotations)
        .onChange(of: routing) { routing in
            guard routing != nil else { return }
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
            steps
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
    
    @ViewBuilder private var steps: some View {
        if let routing = routing, let origin = origin, let destination = destination {
            DirectionsStepsPager(routing: routing, origin: origin, destination: destination, focusedTrack: $focusedTrack, changeRouting: selectTrack)
                .onChange(of: focusedTrack) { _ in } // removing this breaks track focusing from instructions/steps sheet
        }
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
            sheet = .pickDirections(origin: origin, destination: destination, selection: $routing)
        }
    }
    
    private func reset() {
        withAnimation {
            state = .search
            origin = nil
            destination = nil
            annotations = []
            routing = nil
            paths = []
        }
    }
    
    private func updateAnnotations(_ obj: Waypoint? = nil) {
        withAnimation {
            annotations = [origin, destination]
                .compactMap { item -> MKPointAnnotation? in
                    guard let item = item else { return nil }
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.coordinate
                    annotation.title = item.name
                    annotation.subtitle = item.name
                    return annotation
                }
        }
    }
}
