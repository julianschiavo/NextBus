//
//  RecentsList.swift
//  Watch App Extension
//
//  Created by Julian Schiavo on 12/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct RecentsList: View {
    @EnvironmentObject private var store: Store
    
    var body: some View {
        contents
            .navigationTitle("Recents")
            .navigationTitleDisplayMode(.inline)
    }
    
    @ViewBuilder var contents: some View {
        if store.recents.all.isEmpty {
            placeholder
        } else {
            list
        }
    }
    
    private var list: some View {
        List(store.recents.all) { routeStop in
            RouteETARow(routeStop: routeStop)
        }
        .listStyle(CarouselListStyle())
    }
    
    private var placeholder: some View {
        VStack(alignment: .center, spacing: 15) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.title2, weight: .heavy)
            Text("No Recents")
                .font(.title2, weight: .bold)
        }
    }
}
