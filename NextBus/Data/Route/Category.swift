//
//  Category.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

enum Category: Int, CaseIterable, Codable {
    case bus = 1
    case minibus = 2
    
    var name: String {
        switch self {
        case .bus:
            return "Bus"
        case .minibus:
            return "Minibus"
        }
    }
    
    var iconName: String {
        switch self {
        case .bus:
            return "bus.doubledecker.fill"
        case .minibus:
            return "bus.fill"
        }
    }
    
    var urlKey: String {
        switch self {
        case .bus:
            return "bus"
        case .minibus:
            return "minibus"
        }
    }
    
    // MARK: - Intents
    
    var intent: INCategory {
        switch self {
        case .bus: return .bus
        case .minibus: return .minibus
        }
    }
    
    static func from(_ intent: INCategory) -> Self {
        switch intent {
        case .bus: return .bus
        case .minibus: return .minibus
        default:
            return .bus
        }
    }
}
