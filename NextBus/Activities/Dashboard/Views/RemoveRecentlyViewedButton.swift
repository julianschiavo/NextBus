//
//  RemoveRecentlyViewedButton.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct RemoveRecentlyViewedButton: View {
    @EnvironmentObject private var store: Store
    
    let route: Route
    let stop: Stop
    
    var body: some View {
        Button(action: remove) {
            Label("Remove from Recently Viewed", systemImage: "eye.slash.fill")
                .alignedHorizontally(to: .leading)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(Color.quaternaryBackground)
        }
    }
    
    private func remove() {
        store.recentlyViewed.remove(route: route, stop: stop)
    }
}
