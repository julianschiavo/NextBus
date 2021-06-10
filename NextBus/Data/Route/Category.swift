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
    case train = 3
    case tram = 4
    case ferry = 5
    
    var name: String {
        switch self {
        case .bus:
            return Localizable.Category.bus
        case .minibus:
            return Localizable.Category.minibus
        case .train:
            return Localizable.Category.train
        case .tram:
            return Localizable.Category.tram
        case .ferry:
            return Localizable.Category.ferry
        }
    }
    
    var iconName: String {
        switch self {
        case .bus:
            return "bus.doubledecker.fill"
        case .minibus:
            return "bus.fill"
        case .train:
            return "tram.tunnel.fill"
        case .tram:
            return "tram.fill"
        case .ferry:
            return "drop.fill"
        }
    }
    
    var urlKey: String {
        switch self {
        case .bus:
            return "bus"
        case .minibus:
            return "minibus"
        default:
            return ""
        }
    }
    
    // MARK: - Intents
    
    var intent: INCategory {
        switch self {
        case .bus: return .bus
        case .minibus: return .minibus
        default: return .unknown
        }
    }
    
    static func from(_ intent: INCategory) -> Self {
        switch intent {
        case .bus: return .bus
        case .minibus: return .minibus
        default: return .bus
        }
    }
}
