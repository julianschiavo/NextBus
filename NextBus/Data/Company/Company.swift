//
//  Company.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation
import Intents
import SwiftUI

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

enum Company: String, CaseIterable, Codable {
    case ctb = "CTB"
    case db = "DB"
    case ferry = "FERRY"
    case gmb = "GMB"
    case kmb = "KMB"
    case kmbCTB = "KMB+CTB"
    case kmbNWFB = "KMB+NWFB"
    case lrtFeeder = "LRTFeeder"
    case lwb = "LWB"
    case lwbCTB = "LWB+CTB"
    case pi = "PI"
    case mtr = "MTR"
    case nlb = "NLB"
    case nwfb = "NWFB"
    case tram = "TRAM"
    case xb = "XB"
    case unknown
    
    var name: String {
        switch self {
        case .ctb: return Localizable.Company.ctb
        case .db: return Localizable.Company.db
        case .ferry: return Localizable.Company.ferry
        case .gmb: return Localizable.Company.gmb
        case .kmb: return Localizable.Company.kmb
        case .kmbCTB: return Localizable.Company.kmbCtb
        case .kmbNWFB: return Localizable.Company.kmbNwfb
        case .lrtFeeder: return Localizable.Company.lrtFeeder
        case .lwb: return Localizable.Company.lwb
        case .lwbCTB: return Localizable.Company.lwbCtb
        case .pi: return Localizable.Company.pi
        case .mtr: return Localizable.Company.mtr
        case .nlb: return Localizable.Company.nlb
        case .nwfb: return Localizable.Company.nwfb
        case .tram: return Localizable.Company.tram
        case .xb: return Localizable.Company.xb
        case .unknown: return Localizable.Company.unknown
        }
    }
    
    var category: Category {
        switch self {
        case .ferry:
            return .ferry
        case .gmb:
            return .minibus
        case .mtr:
            return .train
        case .tram:
            return .tram
        default:
            return .bus
        }
    }
    
    var color: Color {
        switch self {
        case .ctb: return Color(red: 254 / 255, green: 194 / 255, blue: 45 / 255)
        case .db: return Color(red: 169 / 255, green: 121 / 255, blue: 223 / 255)
        case .ferry: return Color(red: 13 / 255, green: 68 / 255, blue: 148 / 255)
        case .gmb: return Color(red: 6 / 255, green: 99 / 255, blue: 73 / 255)
        case .kmb: return Color(red: 216 / 255, green: 38 / 255, blue: 42 / 255)
        case .kmbCTB: return Color(red: 216 / 255, green: 38 / 255, blue: 42 / 255)
        case .kmbNWFB: return Color(red: 216 / 255, green: 38 / 255, blue: 42 / 255)
        case .lrtFeeder: return Color(red: 161 / 255, green: 40 / 255, blue: 64 / 255)
        case .lwb: return Color(red: 231 / 255, green: 93 / 255, blue: 46 / 255)
        case .lwbCTB: return Color(red: 231 / 255, green: 93 / 255, blue: 46 / 255)
        case .pi: return Color(red: 202 / 255, green: 156 / 255, blue: 49 / 255)
        case .mtr: return Color(red: 155 / 255, green: 46 / 255, blue: 60 / 255)
        case .nlb: return Color(red: 24 / 255, green: 58 / 255, blue: 33 / 255)
        case .nwfb: return Color(red: 240 / 255, green: 11 / 255, blue: 43 / 255)
        case .tram: return Color(red: 6 / 255, green: 105 / 255, blue: 65 / 255)
        case .xb: return .primary
        case .unknown: return .primary
        }
    }
    
    #if os(iOS)
    var nativeColor: UIColor {
        UIColor(color)
    }
    #elseif os(macOS)
    var nativeColor: NSColor {
        NSColor(color)
    }
    #endif
    
    var textColor: Color {
        switch self {
        case .gmb, .kmb, .kmbCTB, .kmbNWFB, .lrtFeeder, .lwb, .lwbCTB, .mtr, .nlb, .nwfb, .tram, .xb:
            return Color.white
        default:
            return Color.black
        }
    }
    
    var supportsETA: Bool {
        switch self {
        case .ctb, .gmb, .kmb, .kmbCTB, .kmbNWFB, .lwb, .lwbCTB, .nlb, .nwfb:
            return true
        default:
            return false
        }
    }
    
    // MARK: - Intents
    
    var intent: INCompany {
        switch self {
        case .ctb: return .ctb
        case .db: return .db
        case .gmb: return .gmb
        case .kmb: return .kmb
        case .kmbCTB: return .kmbCTB
        case .kmbNWFB: return .kmbNWFB
        case .lrtFeeder: return .lrtFeeder
        case .lwb: return .lwb
        case .lwbCTB: return .lwbCTB
        case .pi: return .pi
        case .nlb: return .nlb
        case .nwfb: return .nwfb
        case .xb: return .xb
        default: return .unknown
        }
    }
    
    static func from(_ intent: INCompany) -> Self {
        switch intent {
        case .ctb: return .ctb
        case .db: return .db
        case .gmb: return .gmb
        case .kmb: return .kmb
        case .kmbCTB: return .kmbCTB
        case .kmbNWFB: return .kmbNWFB
        case .lrtFeeder: return .lrtFeeder
        case .lwb: return .lwb
        case .lwbCTB: return .lwbCTB
        case .pi: return .pi
        case .nlb: return .nlb
        case .nwfb: return .nwfb
        case .xb: return .xb
        default: return .unknown
        }
    }
}
