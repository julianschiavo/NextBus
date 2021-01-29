//
//  RoutingPicker.swift
//  NextBus
//
//  Created by Julian Schiavo on 27/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import MapKit
import SwiftUI

struct RoutingPicker: View, Loadable {
    @Environment(\.presentationMode) private var presentationMode
    
    let origin: MKMapItem?
    let destination: MKMapItem?
    @Binding var selection: Directions?
    
    var key: DirectionsRequest {
        DirectionsRequest(
            originName: origin?.name,
            originLatitude: origin?.placemark.coordinate.latitude,
            originLongitude: origin?.placemark.coordinate.longitude,
            destinationName: destination?.name,
            destinationLatitude: destination?.placemark.coordinate.latitude,
            destinationLongitude: destination?.placemark.coordinate.longitude
        )
    }
    @StateObject var loader = DirectionsLoader()
    
    var body: some View {
        NavigationView {
            loaderView
                .macMinFrame(width: 700, height: 500)
                .navigationTitle("Which routing?")
                .navigationTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .confirmationAction) {
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func body(with options: [Directions]) -> some View {
        List {
            ForEach(options) { directions in
                group(for: directions)
            }
        }
    }
    
    private func group(for directions: Directions) -> some View {
        RoutingRowGroup(directions: directions) {
            selection = directions
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func placeholder() -> some View {
        ProgressView("Finding Directions...")
    }
}
