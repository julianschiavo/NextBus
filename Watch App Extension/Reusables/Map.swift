//
//  Map.swift
//  Watch App Extension
//
//  Created by Julian Schiavo on 12/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI
import WatchKit

struct Map: WKInterfaceObjectRepresentable {
    
    var latitude: Double
    var longitude: Double
    private var coordinate: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
    
    func makeWKInterfaceObject(context: WKInterfaceObjectRepresentableContext<Map>) -> WKInterfaceMap {
        WKInterfaceMap()
    }
    
    func updateWKInterfaceObject(_ map: WKInterfaceMap, context: WKInterfaceObjectRepresentableContext<Map>) {
        let regionRadius: CLLocationDistance = 300
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        map.setRegion(coordinateRegion)
        
        map.addAnnotation(coordinate, with: .green)
        map.setShowsUserLocation(true)
    }
}
