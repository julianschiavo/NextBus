//
//  NewScheduleButton.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct NewScheduleButton: View {
    @Binding var sheet: Sheet?
    let route: Route
    let stop: Stop
    
    var body: some View {
        Button {
            sheet = .newSchedule(route: route, stop: stop)
        } label: {
            Label(Localizable.Schedule.new, systemImage: "calendar")
                .alignedHorizontally(to: .leading)
                .iOSPadding(.vertical, 10)
                .iOSPadding(.horizontal, 12)
                .iOSBackground(Color.quaternaryBackground)
                .macPadding(.vertical, 8)
                .macPadding(.horizontal, 8)
        }
        .macCustomButton()
    }
}
