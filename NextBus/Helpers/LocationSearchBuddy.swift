//
//  LocationSearchBuddy.swift
//  NextBus
//
//  Created by Julian Schiavo on 24/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation
import MapKit
import SwiftUI

class LocationSearchBuddy: NSObject, ObservableObject, ThrowsErrors, MKLocalSearchCompleterDelegate {
    
    @Published var searchQuery = ""
    @Published var completions = [MKLocalSearchCompletion]()
    @Published var mapItem: MKMapItem?
    @Published var isSearching = false
    @Published var error: IdentifiableError?
    
    private let completer = MKLocalSearchCompleter()
    private var cancellables = Set<AnyCancellable>()
    private var search: MKLocalSearch?
    
    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = [.address, .pointOfInterest]
        
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
    
    func update(fragment: String) {
        completer.queryFragment = fragment
    }
    
    func updateRegion(_ region: CLLocationCoordinate2D) {
        completer.region = MKCoordinateRegion(center: region, latitudinalMeters: 500, longitudinalMeters: 500)
    }
    
    func search(completion: MKLocalSearchCompletion) {
        completer.queryFragment = ""
        completions = []
        search?.cancel()
        
        isSearching = true
        
        let request = MKLocalSearch.Request(completion: completion)
        search = MKLocalSearch(request: request)
        search?.start { [weak self] response, error in
            guard let response = response else {
                self?.isSearching = false
                self?.catchError(error)
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    self?.isSearching = false
                    self?.mapItem = response.mapItems.first
                }
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
