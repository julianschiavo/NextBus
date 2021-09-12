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

@MainActor
class LocationTracker: NSObject, ObservableObject, ThrowsErrors, CLLocationManagerDelegate {
    @Published var location = CLLocation(latitude: 0, longitude: 0)
    @Published var hasPermission = true
    @Published var error: Error?
    
    var hasRequestedPermission: Bool {
        locationManager.authorizationStatus != .notDetermined
    }
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        Task {
            await updatePermissionState()
        }
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
        withAnimation {
            #if os(macOS)
            hasPermission = true
            #else
            hasPermission = locationManager.authorizationStatus == .authorized
            #endif
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else { return }
        withAnimation {
            location = mostRecentLocation
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
