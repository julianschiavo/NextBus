//
//  ScheduleBlock.swift
//  NextBus
//
//  Created by Julian Schiavo on 15/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

struct ScheduleBlock: Codable, Hashable, Identifiable {
    var id = UUID()
    
    let name: String
    
    let startDate: Date
    let endDate: Date
    
    let route: Route
    let stop: Stop
    
    let showsOnWidget: Bool
    let sendsNotifications: Bool
}
