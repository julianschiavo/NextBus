//
//  ScheduleButton.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct ScheduleButton: View {
    let route: Route
    let stop: Stop
    
    var body: some View {
        Button(action: schedule) {
            Label("New Schedule", systemImage: "calendar")
                .alignedHorizontally(to: .leading)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(Color.quaternaryBackground)
        }
    }
    
    private func schedule() {
        
    }
}
