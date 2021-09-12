//
//  DirectionsTab.swift
//  NextBus
//
//  Created by Julian Schiavo on 23/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import MapKit
import SwiftUI

struct DirectionsTab: View {
    
    @State private var sheet: Sheet?
    
    @StateObject private var locationTracker = LocationTracker()
    
    var body: some View {
        iOSNavigationView {
            DirectionsView(sheet: $sheet)
                .macMinFrame(width: 500)
                .navigationTitle(Localizable.Directions.name)
                .navigationTitleDisplayMode(.inline)
        }
        .environmentObject(locationTracker)
        .globalSheet($sheet)
        .navigationViewStyle(.stacks)
    }
}
