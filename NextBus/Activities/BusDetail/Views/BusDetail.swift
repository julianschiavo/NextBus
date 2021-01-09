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
    let direction: Direction
    
    @State private var reload = false
    
    var body: some View {
        List {
            header
            list
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(Localizations.routeTitle(routeName: route.localizedName))
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: reload) { _ in
            return
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: reloadWithAnimation) {
                    Image(systemName: "arrow.clockwise")
                }
            }
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
