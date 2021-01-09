//
//  NLB-Stop.swift
//  NextBus
//
//  Created by Julian Schiavo on 21/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

fileprivate extension Stop {
    static func from(_ stop: NLBModels._Stop, index: Int) -> Stop {
        let name = LocalizedText(en: stop.englishName,
                                 sc: stop.simplifiedChineseName,
                                 tc: stop.traditionalChineseName)
        
        return Stop(
            id: stop.id,
            index: index,
            name: name,
            latitude: stop.latitude,
            longitude: stop.longitude,
            lastUpdated: Date()
        )
    }
}

extension NLBModels {
    struct RawStop: Codable {
        var data: [_Stop]
        
        enum CodingKeys: String, CodingKey {
            case data = "stops"
        }
        
        var stops: [Stop] {
            data.enumerated().map { Stop.from($0.element, index: $0.offset + 1) }
        }
    }

    struct _Stop: Codable, Hashable {
        var id: String
        
        var englishName: String
        var simplifiedChineseName: String
        var traditionalChineseName: String
        
        var normalFare: String
        var holidayFare: String
        
        var specialDeparturesOnlyInt: Int
        var specialDeparturesOnly: Bool { Bool(exactly: specialDeparturesOnlyInt as NSNumber) ?? false }
        
        var latitudeString: String
        var latitude: Double { Double(latitudeString) ?? 0 }
        var longitudeString: String
        var longitude: Double { Double(longitudeString) ?? 0 }
        
        enum CodingKeys: String, CodingKey {
            case id = "stopId"
            case englishName = "stopName_e"
            case simplifiedChineseName = "stopName_s"
            case traditionalChineseName = "stopName_c"
            case normalFare = "fare"
            case holidayFare = "fareHoliday"
            case specialDeparturesOnlyInt = "someDepartureObserveOnly"
            case latitudeString = "latitude"
            case longitudeString = "longitude"
        }
    }
}
