//
//  NWFBCTBETA.swift
//  NextBus
//
//  Created by Julian Schiavo on 20/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

fileprivate extension ETA {
    static func from(_ eta: CTBNWFB._ETA) -> ETA {
        let remark = LocalizedText(en: eta.remarkEN,
                                   sc: eta.remarkSC,
                                   tc: eta.remarkTC)
        
        return ETA(
            id: String(eta.index),
            date: eta.date,
            generated: eta.generated,
            remark: remark
        )
    }
}

extension CTBNWFB {
    struct RawETA: Codable, Hashable {
        var type: String
        var version: String
        var data: [_ETA]
        
        func etas(for direction: Direction) -> [ETA] {
            data
                .filter { $0.direction.direction == direction }
                .map { ETA.from($0) }
        }
    }

    struct _ETA: Codable, Hashable {
        var index: Int
        var dateString: String
        var date: Date? {
            ISO8601DateFormatter().date(from: dateString)
        }
        
        var direction: _Direction
        
        var destinationEN: String
        var destinationSC: String
        var destinationTC: String
        
        var remarkEN: String
        var remarkSC: String
        var remarkTC: String
        
        var generated: Date
        
        enum CodingKeys: String, CodingKey {
            case direction = "dir"
            case index = "eta_seq"
            case dateString = "eta"
            case destinationEN = "dest_en"
            case destinationSC = "dest_sc"
            case destinationTC = "dest_tc"
            case remarkEN = "rmk_en"
            case remarkSC = "rmk_sc"
            case remarkTC = "rmk_tc"
            case generated = "data_timestamp"
        }
    }
}
