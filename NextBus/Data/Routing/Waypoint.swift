//
//  Waypoint.swift
//  NextBus
//
//  Created by Julian Schiavo on 2/2/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation
import MapKit

struct Waypoint: Equatable, Hashable, Identifiable {
    let id: String
    let index: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let _mapItem: MKMapItem?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var mapItem: MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        return _mapItem ?? mapItem
    }
    
    init(id: String, index: Int, name: String, latitude: Double, longitude: Double, mapItem: MKMapItem? = nil) {
        self.id = id
        self.index = index
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self._mapItem = mapItem
    }
}
