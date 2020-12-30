//
//  LocationManager.swift
//  Watch App Extension
//
//  Created by Julian Schiavo on 12/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var userLocation = CLLocation(latitude: 0, longitude: 0)
    
    private let locationManager = CLLocationManager()
    
    func start() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else { return }
        userLocation = mostRecentLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        return
    }
    
    // MARK: Singleton
    
    static let shared = LocationManager()
    
    override private init() {
        super.init()
        start()
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
}
