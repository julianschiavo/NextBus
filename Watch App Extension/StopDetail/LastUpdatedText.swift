//
//  LastUpdatedText.swift
//  Watch App Extension
//
//  Created by Julian Schiavo on 12/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct LastUpdatedText: View {
    let date: Date
    
    var body: some View {
        (Text(Localizable.StopDetail.lastUpdated("")) + Text(date, style: .time))
            .font(.caption2)
            .foregroundColor(.secondary)
            .alignedHorizontally(to: .leading)
            .padding(4)
    }
}
