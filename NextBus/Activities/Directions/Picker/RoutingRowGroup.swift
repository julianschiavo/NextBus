//
//  RoutingRowGroup.swift
//  NextBus
//
//  Created by Julian Schiavo on 28/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct RoutingRowGroup: View {
    let routing: Routing
    let select: () -> Void
    
    @State private var isExpanded = false
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            ForEach(routing.tracks) { track in
                RoutingTrackRow(track: track)
            }
        } label: {
            RoutingRow(directions: directions, select: select)
                .onTapGesture {
                    isExpanded.toggle()
                }
        }
    }
}
