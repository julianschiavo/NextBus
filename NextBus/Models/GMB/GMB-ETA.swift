//
//  GMB-ETA.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

fileprivate extension ETA {
    static func from(_ eta: GMBModels._ETA, generated: Date) -> ETA {
        let remark = LocalizedText(en: eta.remarkEN,
                                   sc: eta.remarkSC,
                                   tc: eta.remarkTC)
        
        return ETA(
            id: String(eta.index),
            date: eta.date,
            generated: generated,
            remark: remark
        )
    }
}

extension GMBModels {
    struct RawETA: Codable, Hashable {
        var type: String
        var version: String
        var generated: Date
        var data: [_ETA]
        
        var etas: [ETA] {
            data.map { ETA.from($0, generated: generated) }
        }
        
        enum CodingKeys: String, CodingKey {
            case type, version, data
            case generated = "generated_timestamp"
        }
    }
    
    struct _ETA: Codable, Hashable {
        var index: Int
        var date: Date
        
        var remarkEN: String
        var remarkSC: String
        var remarkTC: String
        
        enum CodingKeys: String, CodingKey {
            case index = "eta_seq"
            case date = "timestamp"
            case remarkEN = "remarks_en"
            case remarkSC = "remarks_sc"
            case remarkTC = "remarks_tc"
        }
    }
}
