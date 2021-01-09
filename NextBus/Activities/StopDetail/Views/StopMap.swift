//
//  StopMap.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import MapKit
import SwiftUI

struct StopMap: View {
    private struct Item: Identifiable {
        let id = 0
    }
    
    let name: String
    let latitude: Double
    let longitude: Double
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 22.3193,
            longitude: 114.1694
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 10,
            longitudeDelta: 10
        )
    )
    
    var body: some View {
        Map(coordinateRegion: $region, interactionModes: .pan, showsUserLocation: true, annotationItems: [Item()]) { _ in
            MapMarker(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), tint: .green)
        }
        .frame(height: 120)
        .background(Color.quaternaryBackground)
        .onAppear {
            let location = CLLocation(latitude: latitude, longitude: longitude)
            let regionRadius: CLLocationDistance = 400
            withAnimation {
                region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            }
        }
    }
}
