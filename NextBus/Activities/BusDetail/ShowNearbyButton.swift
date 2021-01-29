//
//  ShowNearbyButton.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct ShowNearbyButton: View {
    @ObservedObject var locationTracker: LocationTracker
    
    var body: some View {
        Button {
            locationTracker.requestPermission()
        } label: {
            Label("Show Nearby Bus Stops", systemImage: "location.fill")
        }
    }
}
