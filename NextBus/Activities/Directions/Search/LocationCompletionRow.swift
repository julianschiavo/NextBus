//
//  LocationCompletionRow.swift
//  NextBus
//
//  Created by Julian Schiavo on 28/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import MapKit
import SwiftUI

struct LocationCompletionRow: View {
    let completion: MKLocalSearchCompletion
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            VStack(alignment: .leading) {
                Text(completion.title)
                    .font(.callout, weight: .bold)
                Text(completion.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .macCustomButton()
    }
}
