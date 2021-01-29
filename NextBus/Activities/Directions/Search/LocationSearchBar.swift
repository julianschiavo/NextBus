//
//  LocationSearchBar.swift
//  NextBus
//
//  Created by Julian Schiavo on 24/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import MapKit
import SwiftUI

struct LocationSearchBar: View {
    @EnvironmentObject private var locationTracker: LocationTracker
    
    @Binding var mapItem: MKMapItem?
    let placeholder: String
    var onSearch: () -> Void = { }
    
    @State private var text = ""
    @State private var isFocused = false
    @State private var wasCompletionTapped = false
    
    @StateObject private var searchBuddy = LocationSearchBuddy()
    
    var body: some View {
        VStack {
            SearchBar(text: $text, placeholder: placeholder, isFocused: $isFocused, onEnter: onSearch)
            if isFocused, !wasCompletionTapped, !searchBuddy.completions.isEmpty {
                completions
            }
            if searchBuddy.isSearching {
                ProgressView("Searching...")
                    .padding(6)
            }
        }
        .background(Color.tertiaryBackground)
//        .alert(errorBinding: $searchBuddy.error)
        .onChange(of: locationTracker.location) { location in
            searchBuddy.updateRegion(location.coordinate)
        }
        .onChange(of: text) { query in
            if wasCompletionTapped {
                searchBuddy.completions = []
            } else {
                searchBuddy.searchQuery = query
            }
            wasCompletionTapped = false
        }
        .onChange(of: isFocused) { isFocused in
            if !isFocused, mapItem == nil {
                text = ""
            }
        }
        .onChange(of: searchBuddy.mapItem) { mapItem in
            self.mapItem = mapItem
        }
    }
    
    private var completions: some View {
        List {
            ForEach(searchBuddy.completions) { completion in
                LocationCompletionRow(completion: completion) {
                    wasCompletionTapped = true
                    text = completion.title
                    searchBuddy.search(completion: completion)
                }
            }
            .listRowBackground(Color.tertiaryBackground)
        }
        .frame(maxHeight: 200)
    }
}
