//
//  ServicePeriod.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

enum ServicePeriod: String, CaseIterable, Codable {
    case allDay = "A"
    case night = "N"
    case nightAndSpecial = "NT"
    case day = "R"
    case special = "T"
    
    // MARK: - Intent
    
    var intent: INServicePeriod {
        switch self {
        case .allDay: return .unknown
        case .night: return .night
        case .nightAndSpecial: return .nightAndSpecial
        case .day: return .day
        case .special: return .special
        }
    }
    
    static func from(_ intent: INServicePeriod) -> Self {
        switch intent {
        case .unknown: return .allDay
        case .night: return .night
        case .nightAndSpecial: return .nightAndSpecial
        case .day: return .day
        case .special: return .special
        }
    }
}
