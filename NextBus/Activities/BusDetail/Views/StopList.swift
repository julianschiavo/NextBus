//
//  StopList.swift
//  NextBus
//
//  Created by Julian Schiavo on 6/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import CoreLocation
import SwiftUI

struct StopList: View, Loadable {
    let route: Route
    
    @Binding var reload: Bool
    
    var key: Route { route }
    
    @StateObject var loader = StopsLoader()
    @StateObject private var locationTracker = LocationTracker()
    
    var body: some View {
        loaderView
    }
    
    func body(with stops: [Stop]) -> some View {
        Group {
            locationRequestSection
            nearbyList(stops)
            completeList(stops)
        }
        .onChange(of: reload) { _ in
            loader.loadData(key: key)
        }
    }
    
    @ViewBuilder private var locationRequestSection: some View {
        if !locationTracker.hasPermission && !locationTracker.hasRequestedPermission {
            Section {
                ShowNearbyButton(locationTracker: locationTracker)
            }
        }
    }
    
    private func nearbyList(_ stops: [Stop]) -> some View {
        let nearby = nearbyStops(stops: stops)
        return Section(header: Text(Localizations.nearbyBusStopsHeader)) {
            list(nearby)
        }
    }
    
    private func completeList(_ stops: [Stop]) -> some View {
        Section(header: Text(Localizations.allBusStopsHeader),
                footer: lastUpdateText(for: stops.last)) {
            list(stops)
        }
    }
    
    private func list(_ stops: [Stop]) -> some View {
        Group {
            ForEach(stops) { stop in
                NavigationLink(destination: StopDetail(route: route, stop: stop)) {
                    StopRow(stop: stop)
                }
            }
        }
    }
    
    private func nearbyStops(stops: [Stop]) -> [Stop] {
        stops
            .map { stop -> (stop: Stop, distance: CLLocationDistance) in
                guard let latitude = stop.latitude,
                      let longitude = stop.longitude
                else { return (stop, 400) }
                
                let location = CLLocation(latitude: latitude, longitude: longitude)
                let distance = locationTracker.location.distance(from: location)
                return (stop: stop, distance: distance)
            }
            .filter {
                $0.distance < 300
            }
            .sorted {
                $0.distance < $1.distance
            }
            .map {
                $0.stop
            }
    }
    
    @ViewBuilder private func lastUpdateText(for stop: Stop?) -> some View {
        if let stop = stop {
            Text(Localizations.detailsLastUpdatedFooter(""))
                + Text(stop.lastUpdated, style: .time)
        }
    }
    
    func placeholder() -> some View {
        ProgressView("Loading Stops...")
            .padding(20)
            .aligned(to: .center)
    }
}
