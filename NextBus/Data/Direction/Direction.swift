//
//  Direction.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

enum Direction: String, Codable, Hashable, Identifiable {
    case single
    case inbound
    case outbound
    
    var name: String {
        switch self {
        case .single: return Localizations.oneWay
        case .inbound: return Localizations.inbound
        case .outbound: return Localizations.outbound
        }
    }
    
    var id: String { name }
    
    // official mdb file, used for gmb eta
    var sequence: String {
        switch self {
        case .single, .inbound:
            return "1"
        case .outbound:
            return "2"
        }
    }
    
    static func fromGovSequence(_ sequence: Int) -> Direction? {
        switch sequence {
        case 1: return .inbound
        case 2: return .outbound
        default:
            return nil
        }
    }
    
    // MARK: - Intents
//    
//    static func from(intentObject: INDirection) -> Direction {
//        switch intentObject {
//        case .oneWay: return .single
//        case .inbound: return .inbound
//        case .outbound, .unknown: return .outbound
//        }
//    }
//    
//    var intentObject: INDirection {
//        switch self {
//        case .single: return .oneWay
//        case .inbound: return .inbound
//        case .outbound: return .outbound
//        }
//    }
}
