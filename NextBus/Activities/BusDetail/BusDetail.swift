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
    
    @State private var shouldRefresh = false
    @State private var sheet: Sheet?
    
    var body: some View {
        #if os(iOS)
        contents
        #elseif os(macOS)
        NavigationView {
            contents
                .macMinFrame(width: 300)
                .macMaxFrame(width: 500)
        }
        #endif
    }
    
    private var contents: some View {
        List {
            header
            list
        }
        .refreshable {
            shouldRefresh.toggle()
        }
        .navigationTitle(navigationTitle ?? Localizable.routeName(route.localizedName))
        .navigationTitleDisplayMode(.inline)
        .globalSheet($sheet)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                #if !os(watchOS)
                ShareButton($sheet, route: route)
                #endif
            }
        }
    }
    
    private var header: some View {
        Section {
            BusDetailHeader(route: route)
        }
    }
    
    private var list: some View {
        StopList(route: route, shouldRefresh: $shouldRefresh)
    }
}
