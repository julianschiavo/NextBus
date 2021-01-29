//
//  NextBusLabel.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct ETALabel: View, Loadable {
    let route: Route
    let stop: Stop
    
    @StateObject var loader = ETALoader()
    var key: RouteStop { RouteStop(route: route, stop: stop) }
    
    private let formatter = RelativeDateTimeFormatter()
    
    init(route: Route, stop: Stop) {
        self.route = route
        self.stop = stop
        formatter.formattingContext = .beginningOfSentence
    }
    
    var body: some View {
        loaderView
    }
    
    @ViewBuilder func body(with etas: [ETA]) -> some View {
        if let date = etas.first?.date {
            #if os(iOS)
            Text(date, formatter: formatter)
                .font(.largeHeadline, weight: .bold, withMonospacedDigits: true)
            #else
            Text(date, formatter: formatter)
                .font(.headline, weight: .bold, withMonospacedDigits: true)
            #endif
        }
    }
    
    func placeholder() -> some View {
        ProgressView()
            .padding(5)
    }
}
