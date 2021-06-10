//
//  LastUpdatedText.swift
//  NextBus
//
//  Created by Julian Schiavo on 12/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct LastUpdatedText: View {
    let date: Date
    
    var body: some View {
        (Text(Localizable.StopDetail.lastUpdated("")) + Text(date, style: .time))
            .font(.callout)
            .foregroundColor(.secondary)
            .alignedHorizontally(to: .leading)
            .padding(.vertical, 5)
            .padding(.horizontal, 12)
            .background(Color.secondaryBackground)
    }
}
