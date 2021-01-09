//
//  NWFBCTBETA.swift
//  NextBus
//
//  Created by Julian Schiavo on 20/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

fileprivate extension ETA {
    static func from(_ eta: NWFBCTBModels._ETA) -> ETA {
        let remark = LocalizedText(en: eta.englishRemark,
                                   sc: eta.simplifiedChineseRemark,
                                   tc: eta.traditionalChineseRemark)
        
        return ETA(
            id: String(eta.index),
            date: eta.date,
            generated: eta.generated,
            remark: remark
        )
    }
}

extension NWFBCTBModels {
    struct RawETA: Codable, Hashable {
        var type: String
        var version: String
        var data: [_ETA]
        
        func etas(for direction: Direction) -> [ETA] {
            data
                .filter { $0.direction.direction == direction }
                .map { $0.toModel() }
        }
    }

    struct _ETA: Codable, Hashable {
        var index: Int
        var dateString: String
        var date: Date? {
            ISO8601DateFormatter().date(from: dateString)
        }
        
        var generated: Date
        
        var direction: _Direction
        
        var englishDestination: String
        var simplifiedChineseDestination: String
        var traditionalChineseDestination: String
        
        var englishRemark: String
        var simplifiedChineseRemark: String
        var traditionalChineseRemark: String
        
        func toModel() -> ETA {
            ETA.from(self)
        }
        
        enum CodingKeys: String, CodingKey {
            case direction = "dir"
            case index = "eta_seq"
            case dateString = "eta"
            case generated = "data_timestamp"
            case englishDestination = "dest_en"
            case simplifiedChineseDestination = "dest_sc"
            case traditionalChineseDestination = "dest_tc"
            case englishRemark = "rmk_en"
            case simplifiedChineseRemark = "rmk_sc"
            case traditionalChineseRemark = "rmk_tc"
        }
    }
}
