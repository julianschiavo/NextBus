//
//  RoutingPicker.swift
//  NextBus
//
//  Created by Julian Schiavo on 27/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Loadability
import MapKit
import SwiftUI

struct RoutingPicker: View, LoadableView {
    @Environment(\.dismiss) private var dismiss
    
    let origin: Waypoint
    let destination: Waypoint
    @Binding var selection: Routing?
    
    var key: RoutingRequest {
        RoutingRequest(origin: origin, destination: destination)
    }
    @StateObject var loader = RoutingLoader()
    
    var body: some View {
        NavigationView {
            loaderView
                .macMinFrame(width: 700, height: 500)
                .navigationTitle(Localizable.Directions.whichRoute)
                .navigationTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .confirmationAction) {
                        Button(Localizable.done) {
                            dismiss()
                        }
                    }
                }
        }
        .navigationViewStyle(.stacks)
    }
    
    func body(with options: [Routing]) -> some View {
        List {
            ForEach(options) { directions in
                Section {
                    group(for: directions)
                }
            }
        }
    }
    
    private func group(for routing: Routing) -> some View {
        RoutingRowGroup(routing: routing) {
            selection = routing
            dismiss()
        }
    }
    
    func placeholder() -> some View {
        ProgressView(Localizable.Directions.findingDirections)
    }
}
