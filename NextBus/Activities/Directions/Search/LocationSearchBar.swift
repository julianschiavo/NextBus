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
    
    @Binding var mapItem: MKMapItem?
    let placeholder: String
    var onSearch: () -> Void = { }
    
    @State private var text = ""
    @State private var wasCompletionTapped = false
    
    @StateObject private var searchBuddy = LocationSearchBuddy()
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            searchBar
            if isFocused, !wasCompletionTapped, !searchBuddy.completions.isEmpty {
                completions
            }
            if searchBuddy.isSearching {
                ProgressView(Localizable.Directions.searching)
                    .padding(6)
            }
        }
        .background(.regularMaterial)
        .roundedBorder(8)
//        .alert(errorBinding: $searchBuddy.error)
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
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.largeHeadline, weight: .bold)
            TextField(placeholder, text: $text)
            CurrentLocationButton(searchText: $text, mapItem: $mapItem)
        }
        .font(.largeHeadline)
        .padding(8)
        .submitLabel(.search)
        .focused($isFocused)
    }
    
    private var completions: some View {
        List {
            ForEach(searchBuddy.completions) { completion in
                LocationCompletionRow(completion: completion) {
                    wasCompletionTapped = true
                    text = completion.title
                    Task {
                        await searchBuddy.search(completion: completion)
                    }
                }
            }
            .listRowBackground(Color.clear)
        }
        .background(Material.ultraThin)
        .listRowBackground(Color.clear)
        .frame(maxHeight: 200)
        .listStyle(.plain)
    }
}
