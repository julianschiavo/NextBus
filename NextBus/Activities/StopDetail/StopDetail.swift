//
//  StopDetail.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct StopDetail: View {
    @EnvironmentObject private var store: Store
    
    private let route: Route
    private let stop: Stop
    private let tokens: [Token]
    private let navigationTitle: String
    
    @State private var sheet: Sheet?
    
    @State private var reload = false
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    init(route: Route, stop: Stop, navigationTitle: String? = nil) {
        self.route = route
        self.stop = stop
        self.navigationTitle = navigationTitle ?? stop.localizedName
        self.tokens = Token.tokens(route: route, stop: stop)
    }
    
    var body: some View {
        Layers {
            header
            etas
            info
            map
        }
        .macMinFrame(width: 320)
        .navigationTitle(navigationTitle)
        .navigationTitleDisplayMode(.inline)
        .onAppear {
            store.recents.add(route: route, stop: stop)
        }
        .onReceive(timer) { _ in
            reloadWithAnimation()
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                ShareButton($sheet, route: route, stop: stop)
            }
        }
        .globalSheet($sheet)
    }
    
    private var header: some View {
        Layer(.top, withBorder: false) {
            StopDetailHeader(route: route, stop: stop)
            if !tokens.isEmpty {
                TokenStack(tokens: tokens)
            }
        }
    }
    
    private var etas: some View {
        Layer(.primary, title: Localizable.StopDetail.arrivingSoon, systemImage: "clock.fill") {
            if route.company.supportsETA {
                ETAList(route: route, stop: stop, reload: $reload)
            } else {
                Label(Localizable.StopDetail.arrivalInformationNotAvailable, systemImage: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var info: some View {
        Layer(.secondary, title: Localizable.StopDetail.info, systemImage: "info.circle.fill") {
            VStack(spacing: 0) {
                #if !APPCLIP
                FavoritesButton(route: route, stop: stop)
                Divider()
                #if os(iOS)
                CustomAddToSiriButton(sheet: $sheet, route: route, stop: stop)
                Divider()
                #endif
                NewScheduleButton(sheet: $sheet, route: route, stop: stop)
                Divider()
                #endif
                ShareButton($sheet, route: route, stop: stop)
            }
        }
    }
    
    @ViewBuilder private var map: some View {
        if let latitude = stop.latitude, let longitude = stop.longitude {
            Layer(.tertiary, title: Localizable.StopDetail.map, systemImage: "map.fill") {
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
