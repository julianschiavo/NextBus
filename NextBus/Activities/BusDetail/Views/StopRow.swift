//
//  StopRow.swift
//  NextBus
//
//  Created by Julian Schiavo on 6/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct StopRow: View {
    let stop: Stop
    let distanceInMeters: Int? = nil
    
    var body: some View {
        VStack {
            primary
                .font(.body, withMonospacedDigits: true)
        }
    }
    
    @ViewBuilder private var primary: some View {
        Label(
            title: { Text(stop.localizedName) },
            icon: { Text(String(stop.index)) }
        )
    }
    
    @ViewBuilder private var distance: some View {
        if let distanceInMeters = distanceInMeters {
            Text("\(distanceInMeters) meters away")
        }
    }
}
