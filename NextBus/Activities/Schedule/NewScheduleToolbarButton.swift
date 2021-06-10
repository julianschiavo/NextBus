//
//  NewScheduleToolbarButton.swift
//  NextBus
//
//  Created by Julian Schiavo on 15/2/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct NewScheduleToolbarButton: View {
    @EnvironmentObject var payBuddy: PayBuddy
    
    @Binding var sheet: Sheet?
    
    var body: some View {
        Button {
            if payBuddy.hasPlus {
                sheet = .newSchedule(route: nil, stop: nil)
            } else {
                sheet = .upgrade
            }
        } label: {
            Image(systemName: "plus")
        }
    }
}
