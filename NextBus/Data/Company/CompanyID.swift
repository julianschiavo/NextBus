//
//  CompanyID.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation
import SwiftUI

enum CompanyID: String, CaseIterable, Codable {
    case ctb = "CTB"
    case db = "DB"
    case gmb = "GMB"
    case kmb = "KMB"
    case kmbCTB = "KMB+CTB"
    case kmbNWFB = "KMB+NWFB"
    case lrtFeeder = "LRTFeeder"
    case lwb = "LWB"
    case lwbCTB = "LWB+CTB"
    case pi = "PI"
    case nlb = "NLB"
    case nwfb = "NWFB"
    case xb = "XB"
    case unknown
    
    var name: String {
        switch self {
        case .ctb: return "Citybus"
        case .db: return "Discovery Bay Bus"
        case .gmb: return "Green Minibus"
        case .kmb: return "KMB"
        case .kmbCTB: return "KMB & Citybus"
        case .kmbNWFB: return "KMB & NWFB"
        case .lrtFeeder: return "MTR Feeder"
        case .lwb: return "Long Win Bus"
        case .lwbCTB: return "Long Win Bus & Citybus"
        case .pi: return "Ma Wan Bus"
        case .nlb: return "New Lantao Bus"
        case .nwfb: return "NWFB"
        case .xb: return "LMC Coach"
        case .unknown: return "Unknown"
        }
    }
    
    var category: Category {
        switch self {
        case .gmb:
            return .minibus
        default:
            return .bus
        }
    }
    
    var color: Color {
        switch self {
        case .ctb: return Color(red: 254 / 255, green: 194 / 255, blue: 45 / 255)
        case .db: return Color(red: 169 / 255, green: 121 / 255, blue: 223 / 255)
        case .gmb: return Color(red: 6 / 255, green: 99 / 255, blue: 73 / 255)
        case .kmb: return Color(red: 216 / 255, green: 38 / 255, blue: 42 / 255)
        case .kmbCTB: return Color(red: 216 / 255, green: 38 / 255, blue: 42 / 255)
        case .kmbNWFB: return Color(red: 216 / 255, green: 38 / 255, blue: 42 / 255)
        case .lrtFeeder: return Color(red: 161 / 255, green: 40 / 255, blue: 64 / 255)
        case .lwb: return Color(red: 231 / 255, green: 93 / 255, blue: 46 / 255)
        case .lwbCTB: return Color(red: 231 / 255, green: 93 / 255, blue: 46 / 255)
        case .pi: return Color(red: 202 / 255, green: 156 / 255, blue: 49 / 255)
        case .nlb: return Color(red: 24 / 255, green: 58 / 255, blue: 33 / 255)
        case .nwfb: return Color(red: 240 / 255, green: 11 / 255, blue: 43 / 255)
        case .xb: return .primary
        case .unknown: return .primary
        }
    }
    
    var textColor: Color {
        switch self {
        case .gmb, .kmb, .kmbCTB, .kmbNWFB, .lrtFeeder, .nlb, .nwfb, .xb:
            return Color.white
        default:
            return Color.black
        }
    }
    
    var supportsETA: Bool {
        switch self {
        case .ctb, .gmb, .kmb, .kmbCTB, .kmbNWFB, .nlb, .nwfb:
            return true
        default:
            return false
        }
    }
}
