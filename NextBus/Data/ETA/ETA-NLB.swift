//
//  NLB-ETA.swift
//  NextBus
//
//  Created by Julian Schiavo on 23/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

fileprivate extension ETA {
    static func from(_ eta: NLB._ETA) -> ETA {
        ETA(
            date: eta.date,
            generated: eta.generated,
            remark: LocalizedText(eta.remark)
        )
    }
}

extension NLB {
    struct RawETA: Codable, Hashable {
        var data: [_ETA]
        
        var rawMessage: String
        var message: String { rawMessage.replacingOccurrences(of: "<br />", with: "\n") }
        
        enum CodingKeys: String, CodingKey {
            case data = "estimatedArrivals"
            case rawMessage = "message"
        }
        
        func etas(for route: Route) -> [ETA] {
            data.map { ETA.from($0) }
        }
    }

    struct _ETA: Codable, Hashable {
        var date: Date
        
        var hasDepartedInt: Int
        var hasDeparted: Bool { Bool(exactly: hasDepartedInt as NSNumber) ?? false }
        
        var remark: String
        
        var generated: Date
        
        enum CodingKeys: String, CodingKey {
            case date = "estimatedArrivalTime"
            case hasDepartedInt = "departed"
            case remark = "routeVariantName"
            case generated = "generateTime"
        }
    }
}
