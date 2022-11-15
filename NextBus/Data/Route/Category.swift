//
//  Category.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation
import SwiftUI

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
    
    var image: Image {
        switch self {
        case .bus:
            return Image("bus.doubledecker.hk.fill")
        case .minibus:
            return Image(systemName: "bus.fill")
        case .train:
            return Image(systemName: "tram.tunnel.fill")
        case .tram:
            return Image(systemName: "tram.fill")
        case .ferry:
            return Image(systemName: "drop.fill")
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
