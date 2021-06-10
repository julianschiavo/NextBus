//
//  CurrentScheduleCard.swift
//  NextBus
//
//  Created by Julian Schiavo on 15/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import SwiftUI

struct CurrentScheduleCard: View {
    @EnvironmentObject private var store: Store
    
    private var currentSchedule: ScheduleBlock? {
        store.schedule.all
            .first {
                ($0.startDate...$0.endDate).contains(Date())
            }
    }
    
    var body: some View {
        if let block = currentSchedule {
            Card(Localizable.Dashboard.currentSchedule(block.name), systemImage: "calendar") {
                RouteArrivalRow(routeStop: RouteStop(route: block.route, stop: block.stop))
            }
        }
    }
}
