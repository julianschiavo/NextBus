//
//  RoutingPath.swift
//  NextBus
//
//  Created by Julian Schiavo on 29/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import MapKit

class RoutingPath: MKPolyline {
    let track: RoutingTrack
    var polylines: [MKPolyline]
    
    init(track: RoutingTrack, polylines: [MKPolyline]) {
        self.track = track
        self.polylines = polylines
    }
}
