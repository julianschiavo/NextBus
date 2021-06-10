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
        case .single: return Localizable.oneWay
        case .inbound: return Localizable.inbound
        case .outbound: return Localizable.outbound
        }
    }
    
    var id: String {
        switch self {
        case .single: return "S"
        case .inbound: return "I"
        case .outbound: return "O"
        }
    }
    
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
    
    // MARK: - Intent
    
    var intent: INDirection {
        switch self {
        case .single: return .oneWay
        case .inbound: return .inbound
        case .outbound: return .outbound
        }
    }
    
    static func from(_ intent: INDirection) -> Self {
        switch intent {
        case .oneWay, .unknown: return .single
        case .inbound: return .inbound
        case .outbound: return .outbound
        }
    }
}
