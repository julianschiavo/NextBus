//
//  StopRow.swift
//  NextBus
//
//  Created by Julian Schiavo on 6/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct StopRow: View {
    let route: Route
    let stop: Stop
    
    @State private var isShareSheetPresented = false
    
    var body: some View {
        VStack {
            primary
                .font(.body, withMonospacedDigits: true)
        }
        .sheet(isPresented: $isShareSheetPresented) {
            RouteShareSheet(route: route, stop: stop)
        }
        .contextMenu {
            #if !APPCLIP
            FavoritesButton(route: route, stop: stop)
            #endif
            ShareButton(isPresented: $isShareSheetPresented)
        }
    }
    
    @ViewBuilder private var primary: some View {
        Label(
            title: { Text(stop.localizedName) },
            icon: { Text(String(stop.index)) }
        )
    }
}
