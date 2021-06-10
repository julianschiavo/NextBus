//
//  ScheduleInfoCard.swift
//  NextBus
//
//  Created by Julian Schiavo on 15/2/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct ScheduleInfoCard: View {
    var body: some View {
        Card {
            Text(Localizable.Schedule.description)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .layoutPriority(1)
                .background(Color.secondaryBackground)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .layoutPriority(1)
    }
}
