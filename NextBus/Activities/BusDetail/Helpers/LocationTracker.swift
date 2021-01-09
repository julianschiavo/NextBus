//
//  LocationTracker.swift
//  NextBus
//
//  Created by Julian Schiavo on 6/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import CoreLocation
import Foundation

class LocationTracker: NSObject, ObservableObject, ThrowsErrors, CLLocationManagerDelegate {
    @Published var location = CLLocation(latitude: 0, longitude: 0)
    @Published var error: IdentifiableError?
    
    var hasPermission: Bool {
//        locationManager.authorizationStatus == .authorizedWhenInUse
        false
    }
    
    var hasRequestedPermission: Bool {
        locationManager.authorizationStatus != .notDetermined
    }
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
    
    func requestPermission() {
        guard !hasPermission else { return }
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else { return }
        DispatchQueue.main.async {
            self.location = mostRecentLocation
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManager.startUpdatingLocation()
        DispatchQueue.main.async {
//            let actualLocation = self.location
//            self.location = CLLocation(latitude: 0, longitude: 0)
//            self.location = actualLocation
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        catchError(error)
    }
}
