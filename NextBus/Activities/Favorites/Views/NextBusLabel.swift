//
//  NextBusLabel.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct NextBusLabel: View, Loadable {
    let route: Route
    let stop: Stop
    
    @StateObject var loader = ETALoader()
    var key: ETARequest { ETARequest(route: route, stop: stop) }
    
    var body: some View {
        loaderView
    }
    
    @ViewBuilder func body(with etas: [ETA]) -> some View {
        if let date = etas.first?.date {
            (Text(Localizations.detailsInPrefix) + Text(date, style: .relative))
                .font(.largeHeadline, withMonospacedDigits: true)
        }
    }
    
    func placeholder() -> some View {
        ProgressView()
    }
}
