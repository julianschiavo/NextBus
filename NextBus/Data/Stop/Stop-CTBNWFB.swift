//
//  NWFBCTBStop.swift
//  NextBus
//
//  Created by Julian Schiavo on 20/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

fileprivate extension Stop {
    static func from(_ stop: CTBNWFB.RawStop) -> Stop {
        let name = LocalizedText(en: stop.data.nameEN,
                                 sc: stop.data.nameSC,
                                 tc: stop.data.nameTC)
        return Stop(
            id: stop.data.id,
            index: 0,
            name: name,
            latitude: stop.data.latitude,
            longitude: stop.data.longitude,
            lastUpdated: stop.generated
        )
    }
}

extension CTBNWFB {
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
        var companyID: CompanyID
        var id: String
        
        var index: Int
        var route: String
        var direction: CTBNWFB._Direction
        
        var generated: Date
        
        enum CodingKeys: String, CodingKey {
            case companyID = "co"
            case id = "stop"
            case index = "seq"
            case route = "route"
            case direction = "dir"
            case generated = "data_timestamp"
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
        
        var stop: Stop {
            Stop.from(self)
        }
    }

    struct _Stop: Codable, Hashable {
        var id: String
        
        var nameEN: String
        var nameSC: String
        var nameTC: String
        
        var latitudeString: String
        var latitude: Double { Double(latitudeString) ?? 0 }
        
        var longitudeString: String
        var longitude: Double { Double(longitudeString) ?? 0 }
        
        var generated: Date
        
        enum CodingKeys: String, CodingKey {
            case id = "stop"
            case nameEN = "name_en"
            case nameSC = "name_sc"
            case nameTC = "name_tc"
            case latitudeString = "lat"
            case longitudeString = "long"
            case generated = "data_timestamp"
        }
    }
}
