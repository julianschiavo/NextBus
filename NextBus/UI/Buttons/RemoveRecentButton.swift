//
//  RemoveRecentButton.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct RemoveRecentButton: View {
    @EnvironmentObject private var store: Store
    
    let route: Route
    let stop: Stop
    
    var body: some View {
        Button(action: remove) {
            Label("Remove from Recents", systemImage: "eye.slash.fill")
                .alignedHorizontally(to: .leading)
                .iOSPadding(.vertical, 10)
                .iOSPadding(.horizontal, 12)
                .iOSBackground(Color.quaternaryBackground)
                .macPadding(.vertical, 8)
                .macPadding(.horizontal, 8)
        }
        .macCustomButton()
    }
    
    private func remove() {
        store.recents.remove(route: route, stop: stop)
    }
}
