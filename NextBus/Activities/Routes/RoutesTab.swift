//
//  RoutesTab.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct RoutesTab: View {
    var body: some View {
        NavigationView {
            RoutesList()
                .navigationTitle(Localizable.Routes.name)
        }
        .navigationViewStyle(.stacks)
    }
}
