//
//  LocationTracker.swift
//  NextBus
//
//  Created by Julian Schiavo on 6/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import CoreLocation
import Loadability
import SwiftUI

class LocationTracker: NSObject, ObservableObject, ThrowsErrors, CLLocationManagerDelegate {
    @Published var location = CLLocation(latitude: 0, longitude: 0)
    @Published var hasPermission = true
    @Published var error: IdentifiableError?
    
    var hasRequestedPermission: Bool {
        locationManager.authorizationStatus != .notDetermined
    }
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        updatePermissionState()
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
    
    func requestPermission() {
        guard !hasPermission else { return }
        #if os(macOS)
        locationManager.requestLocation()
        #endif
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func updatePermissionState() {
        DispatchQueue.main.async {
            withAnimation {
                #if os(macOS)
                self.hasPermission = true
                #else
                self.hasPermission = self.locationManager.authorizationStatus == .authorized
                #endif
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else { return }
        DispatchQueue.main.async {
            withAnimation {
                self.location = mostRecentLocation
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        updatePermissionState()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        catchError(error)
    }
}
