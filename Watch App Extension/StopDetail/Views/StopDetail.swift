//
//  StopDetail.swift
//  NextBus
//
//  Created by Julian Schiavo on 12/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct StopDetail: View {
    @EnvironmentObject private var store: Store
    
    let route: Route
    let stop: Stop
    
    @State private var reload = false
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header
                etas
                info
                map
            }
            .padding(.top, 8)
        }
        .onAppear {
            store.recents.add(route: route, stop: stop)
        }
        .onChange(of: reload) { _ in
            return
        }
        .onReceive(timer) { _ in
            reloadWithAnimation()
        }
    }
    
    private var header: some View {
        StopDetailHeader(route: route, stop: stop)
    }
    
    private var etas: some View {
        Card("Arriving Soon", systemImage: "clock.fill") {
            if route.company.supportsETA {
                ETAList(route: route, stop: stop, reload: $reload)
            } else {
                Label("Arrival information is not yet available for this route.", systemImage: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
            }
        }
    }
    
    private var info: some View {
        Card("Info", systemImage: "info.circle.fill") {
            VStack(spacing: 0) {
                FavoritesButton(route: route, stop: stop)
            }
        }
    }
    
    @ViewBuilder private var map: some View {
        if let latitude = stop.latitude, let longitude = stop.longitude {
            Card("Map", systemImage: "map.fill") {
                VStack(spacing: 0) {
                    StopMap(name: stop.localizedName, latitude: latitude, longitude: longitude)
                    Divider()
                    DirectionsButton(name: stop.localizedName, latitude: latitude, longitude: longitude)
                }
            }
        }
    }
    
    private func reloadWithAnimation() {
        withAnimation {
            reload.toggle()
        }
    }
}
