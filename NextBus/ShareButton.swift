//
//  ShareButton.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct ShareButton: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        Button(action: share) {
            Label("Share", systemImage: "square.and.arrow.up")
                .alignedHorizontally(to: .leading)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(Color.quaternaryBackground)
        }
    }
    
    private func share() {
        isPresented = true
    }
}

struct RouteShareSheet: View {
    let route: Route
    var stop: Stop?
    
    private var shareURL: URL {
        var url = URL(string: "https://nextbus.schiavo.me/")!
            .appendingPathComponent(route.companyID.rawValue)
            .appendingPathComponent(route.id)
        if let stop = stop {
            url.appendPathComponent(stop.id)
        }
        return url
    }
    
    var body: some View {
        ShareSheet(items: [shareURL], activities: nil)
    }
}
