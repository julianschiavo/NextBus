//
//  NWFBCTBStop.swift
//  NextBus
//
//  Created by Julian Schiavo on 20/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

fileprivate extension Stop {
    static func from(_ stop: NWFBCTBModels.RawStop, generated: Date) -> Stop {
        let name = LocalizedText(en: stop.data.englishName,
                                 sc: stop.data.simplifiedChineseName,
                                 tc: stop.data.traditionalChineseName)
        return Stop(
            id: stop.data.id,
            index: 0,
            name: name,
            latitude: stop.data.latitude,
            longitude: stop.data.longitude,
            lastUpdated: generated
        )
    }
}

extension NWFBCTBModels {
    struct RawUnknownStop: Codable, Hashable {
        var type: String
        var version: String
        var data: [UnknownStop]
        var generated: Date
        
        enum CodingKeys: String, CodingKey {
            case type
            case version
            case data
            case generated = "generated_timestamp "
        }
        
        var unknownStops: [UnknownStop] {
            for var stop in data {
                stop.generated = generated
            }
            return data
        }
    }

    struct UnknownStop: Codable, Hashable {
        var id: String
        var index: Int
        var generated: Date
        
        var companyID: String
        var route: String
        var direction: NWFBCTBModels._Direction
        
        enum CodingKeys: String, CodingKey {
            case id = "stop"
            case index = "seq"
            case generated = "data_timestamp"
            case companyID = "co"
            case route = "route"
            case direction = "dir"
        }
    }

    struct RawStop: Codable, Hashable {
        var type: String
        var version: String
        var data: _Stop
        var generated: Date
        
        enum CodingKeys: String, CodingKey {
            case type
            case version
            case data
            case generated = "generated_timestamp "
        }
        
        func toModel() -> Stop {
            Stop.from(self, generated: generated)
        }
    }

    struct _Stop: Codable, Hashable {
        var id: String
        
        var englishName: String
        var simplifiedChineseName: String
        var traditionalChineseName: String
        
        var latitudeString: String
        var latitude: Double { Double(latitudeString) ?? 0 }
        
        var longitudeString: String
        var longitude: Double { Double(longitudeString) ?? 0 }
        
        enum CodingKeys: String, CodingKey {
            case id = "stop"
            case englishName = "name_en"
            case simplifiedChineseName = "name_sc"
            case traditionalChineseName = "name_tc"
            case latitudeString = "lat"
            case longitudeString = "long"
        }
    }
}
