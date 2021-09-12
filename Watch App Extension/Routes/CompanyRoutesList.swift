//
//  CompanyRoutesList.swift
//  NextBus
//
//  Created by Julian Schiavo on 12/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct CompanyRoutesList: View {
    
    let routes: [Route]
    @Binding var searchText: String
    
    var body: some View {
        List {
            TextField(Localizable.search, text: $searchText)
            if searchText.isEmpty {
                list
            } else {
                filteredList
            }
        }
        .listStyle(.carousel)
    }
    
    private var list: some View {
        ForEach(routes) { route in
            RouteRow(route: route)
        }
    }
    
    private var filteredList: some View {
        let filtered = routes.filter { searchText.isEmpty || $0.localizedName.localizedLowercase.hasPrefix(searchText.localizedLowercase) }
        
        return ForEach(filtered) { route in
            RouteRow(route: route)
        }
    }
}
