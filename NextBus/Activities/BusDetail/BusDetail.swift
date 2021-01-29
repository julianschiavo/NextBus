//
//  BusDetail.swift
//  NextBus
//
//  Created by Julian Schiavo on 6/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct BusDetail: View {
    let route: Route
    var navigationTitle: String? = nil
    
    @State private var reload = false
    @State private var sheet: Sheet?
    
    var body: some View {
        #if os(iOS)
        contents
        #elseif os(macOS)
        NavigationView {
            contents
                .macMinFrame(width: 270)
        }
        #endif
    }
    
    private var contents: some View {
        List {
            header
            list
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(navigationTitle ?? Localizations.routeTitle(routeName: route.localizedName))
        .navigationTitleDisplayMode(.inline)
        .globalSheet($sheet)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                #if !os(watchOS)
                ShareButton($sheet, route: route)
                Button(action: reloadWithAnimation) {
                    Image(systemName: "arrow.clockwise")
                }
                #endif
            }
        }
        .onChange(of: reload) { _ in
            return
        }
    }
    
    private var header: some View {
        Section {
            BusDetailHeader(route: route)
        }
    }
    
    private var list: some View {
        StopList(route: route, reload: $reload)
    }
    
    private func reloadWithAnimation() {
        withAnimation {
            reload.toggle()
        }
    }
}
