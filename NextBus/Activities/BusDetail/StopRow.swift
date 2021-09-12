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
    
    @State private var sheet: Sheet?
    
    var body: some View {
        VStack {
            primary
                .font(.body, withMonospacedDigits: true)
        }
        .globalSheet($sheet)
        .contextMenu {
            ShareButton($sheet, route: route, stop: stop)
            #if !APPCLIP
            FavoritesButton(route: route, stop: stop)
            #endif
        }
    }
    
    @ViewBuilder private var primary: some View {
        Label(
            title: { Text(stop.localizedName) },
            icon: { Text(String(stop.index)) }
        )
    }
}
