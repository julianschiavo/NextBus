//
//  NWFBCTB-Direction.swift
//  NextBus
//
//  Created by Julian Schiavo on 6/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

extension NWFBCTBModels {
    enum _Direction: String, Codable, Hashable {
        case inbound = "I"
        case outbound = "O"
        
        var parameter: String {
            switch self {
            case .inbound: return "inbound"
            case .outbound: return "outbound"
            }
        }
        
        var direction: Direction {
            switch self {
            case .inbound: return .inbound
            case .outbound: return .outbound
            }
        }
        
        static func from(_ direction: Direction) -> Self {
            switch direction {
            case .single: fatalError("NWFBCTBDirection does not support one way routes")
            case .inbound: return self.inbound
            case .outbound: return self.outbound
            }
        }
    }
}
