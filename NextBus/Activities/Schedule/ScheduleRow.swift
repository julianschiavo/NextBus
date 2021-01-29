//
//  ScheduleRow.swift
//  NextBus
//
//  Created by Julian Schiavo on 23/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct ScheduleRow: View {
    let block: ScheduleBlock
    
    @Binding var sheet: Sheet?
    
    var body: some View {
        Card(block.name) {
            RouteArrivalRow(routeStop: RouteStop(route: block.route, stop: block.stop)) {
                EditScheduleButton {
                    sheet = .editSchedule(block: block)
                }
                DeleteScheduleButton(block: block)
            }
        }
    }
}
