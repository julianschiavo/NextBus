//
//  StopListView.swift
//  Watch App Extension
//
//  Created by Julian Schiavo on 8/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct StopListView: View {
    
    @ObservedObject var locationManager = LocationManager.shared
    
    let route: Route
    let direction: Direction
    
    @State private var shouldRefresh = false
    @State private var error: Error?
    
    init(route: Route, direction: Direction) {
        self.route = route
        self.direction = direction
    }
    
    func refresh() {
        APIManager.shared.updateStops(for: route, includingCached: true, priority: .normal) { error in
            self.error = error
            self.shouldRefresh.toggle()
        }
    }
    
    var body: some View {
        let hasCachedStops = APIManager.shared.hasCachedStops(for: route, in: direction)
        let stops = APIManager.shared.stops(for: route, in: direction)?.contents ?? []
        let nearbyStops = stops.filter {
            let location = CLLocation(latitude: $0.latitude, longitude: $0.longitude)
            let distance = locationManager.userLocation.distance(from: location)
            return distance < 200
        }
        
        let header = VStack(alignment: .leading) {
            Text(Localizations.routeTitle(routeName: route.name)).font(.headline)
            Text(Localizations.routeOriginAndDestination(origin: direction.origin(for: route), destination: direction.destination(for: route))).font(.subheadline)
        }
        .buttonStyle(PlainButtonStyle())
        .padding([.top, .bottom])
        
        let list = List {
            header
            
            if !nearbyStops.isEmpty {
                Section(header: Text(Localizations.nearbyBusStopsHeader)) {
                    ForEach(nearbyStops) { stop in
                        StopCell(route: self.route, direction: self.direction, stop: stop)
                    }
                }
            }
                
            Section(header: Text(Localizations.allBusStopsHeader)) {
                ForEach(stops) { stop in
                    StopCell(route: self.route, direction: self.direction, stop: stop)
                }
            }
        }
        .onAppear { self.locationManager.requestLocation() }
        .listStyle(PlainListStyle())
        .navigationBarTitle(Localizations.busStopsHeader)
        
        if let error = error {
            return Erase {
                Message(imageName: "exclamationmark.triangle",
                        title: Localizations.error,
                        subtitle: error.localizedDescription) {
                    self.refresh()
                }
            }
            
        } else if !hasCachedStops {
            return Erase {
                Message(imageName: "stopwatch",
                        title: Localizations.loadingBusStopsTitle,
                        subtitle: Localizations.loadingBusStopsText) {
                    self.refresh()
                }
            }
            
        } else if stops.isEmpty {
            return Erase {
                Message(imageName: "nosign",
                        title: Localizations.errorNoBusStopsTitle,
                        subtitle: Localizations.errorNoBusStopsText) {
                    self.refresh()
                }
            }
            
        } else {
            return Erase { list }
        }
    }
}
