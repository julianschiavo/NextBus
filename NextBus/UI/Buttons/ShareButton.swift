//
//  ShareButton.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct ShareButton: View {
    @Binding var sheet: Sheet?
    let route: Route
    let stop: Stop?
    
    init(_ sheet: Binding<Sheet?>, route: Route, stop: Stop? = nil) {
        self._sheet = sheet
        self.route = route
        self.stop = stop
    }
    
    var body: some View {
        Button {
            sheet = .shareSheet(route: route, stop: stop)
        } label: {
            Label(Localizable.share, systemImage: "square.and.arrow.up")
                .alignedHorizontally(to: .leading)
                .iOSPadding(.vertical, 10)
                .iOSPadding(.horizontal, 12)
                .iOSBackground(Color.quaternaryBackground)
                .macPadding(.vertical, 8)
                .macPadding(.horizontal, 8)
        }
        .macCustomButton()
    }
}

