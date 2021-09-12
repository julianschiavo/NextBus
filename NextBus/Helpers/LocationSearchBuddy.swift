//
//  LocationSearchBuddy.swift
//  NextBus
//
//  Created by Julian Schiavo on 24/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation
import Loadability
import MapKit
import SwiftUI

@MainActor
class LocationSearchBuddy: NSObject, ObservableObject, ThrowsErrors, MKLocalSearchCompleterDelegate {
    
    @Published var searchQuery = ""
    @Published var completions = [MKLocalSearchCompletion]()
    @Published var mapItem: MKMapItem?
    @Published var isSearching = false
    @Published var error: Error?
    
    private let completer = MKLocalSearchCompleter()
    private var cancellables = Set<AnyCancellable>()
    private var search: MKLocalSearch?
    
    override init() {
        super.init()
        completer.delegate = self
        completer.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 22.3193, longitude: 114.1694), latitudinalMeters: 28000, longitudinalMeters: 28000)
        completer.resultTypes = [.address, .pointOfInterest]
        
        Task {
            await MainActor.run {
                $searchQuery
                    .sink { [weak self] query in
                        guard let self = self else { return }
                        self.search?.cancel()
                        self.mapItem = nil
                        self.isSearching = false
                        self.completer.queryFragment = query
                    }
                    .store(in: &cancellables)
            }
        }
    }
    
    func update(fragment: String) {
        completer.queryFragment = fragment
    }
    
    func search(completion: MKLocalSearchCompletion) async {
        completer.queryFragment = ""
        completions = []
        search?.cancel()
        
        isSearching = true
        
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)
        self.search = search
        
        do {
            let response = try await search.start()
            withAnimation {
                isSearching = false
                mapItem = response.mapItems.first
            }
        } catch {
            withAnimation {
                isSearching = false
                catchError(error)
            }
        }
    }
    
    // MARK: - MKLocalSearchCompleterDelegate
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        withAnimation {
            completions = completer.results
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        catchError(error)
    }
}

extension MKLocalSearchCompletion: Identifiable {
    public var id: String {
        title
    }
}
