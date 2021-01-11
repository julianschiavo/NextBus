//
//  GMB-Stop.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

fileprivate extension Stop {
    static func from(_ stop: GMB._Stop, generated: Date) -> Stop {
        let name = LocalizedText(en: stop.nameEN,
                                 sc: stop.nameSC,
                                 tc: stop.nameTC)
        
        return Stop(
            id: String(stop.id),
            index: stop.index,
            name: name,
            lastUpdated: generated
        )
    }
}

extension GMB {
    struct RawStop: Codable {
        struct Data: Codable {
            var data: [_Stop]
            
            enum CodingKeys: String, CodingKey {
                case data = "route_stops"
            }
        }
        
        var version: String
        var data: Data
        var generated: Date
        
        enum CodingKeys: String, CodingKey {
            case version
            case data
            case generated = "generated_timestamp"
        }
        
        var stops: [Stop] {
            data.data.map { Stop.from($0, generated: generated) }
        }
    }
    
    struct _Stop: Codable, Hashable {
        var id: Int
        var index: Int
        
        var nameEN: String
        var nameSC: String
        var nameTC: String
        
        enum CodingKeys: String, CodingKey {
            case id = "stop_id"
            case index = "stop_seq"
            case nameEN = "name_en"
            case nameSC = "name_sc"
            case nameTC = "name_tc"
        }
    }
}
