//
//  ETARow.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct ETARow: View {
    let eta: ETA
    
    private let formatter = RelativeDateTimeFormatter()
    
    init(eta: ETA) {
        self.eta = eta
        formatter.formattingContext = .beginningOfSentence
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            countdown
            time
            if !eta.localizedRemark.isEmpty {
                Text(eta.localizedRemark)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .alignedHorizontally(to: .leading)
        .iOSPadding(.vertical, 8)
        .macPadding(.vertical, 8)
        .watchPadding(.vertical, 4)
        .iOSPadding(.horizontal, 12)
        .macPadding(.horizontal, 12)
        .watchPadding(.horizontal, 4)
    }
    
    @ViewBuilder private var countdown: some View {
        if let date = eta.date {
            Text(date, formatter: formatter)
                .font(.body, withMonospacedDigits: true)
        }
    }
    
    @ViewBuilder private var time: some View {
        if let date = eta.date {
            (Text(Localizations.detailsAtPrefix) + Text(date, style: .time))
                .font(.footnote, withMonospacedDigits: true)
                .foregroundColor(.secondary)
        }
    }
}
