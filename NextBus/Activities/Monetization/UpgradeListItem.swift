//
//  UpgradeListItem.swift
//  NextBus
//
//  Created by Julian Schiavo on 14/2/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct UpgradeListItem: View {
    let title: String
    let description: String
    let systemImage: String
    
    var body: some View {
        HStack(spacing: 24) {
            Image(systemName: systemImage)
                .font(.largeTitle, weight: .heavy)
                .alignmentGuide(.labelText) { d in d[.trailing] }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.largeHeadline, weight: .bold)
                Text(description)
            }
        }
    }
}
