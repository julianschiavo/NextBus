//
//  GOV-Stop.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

fileprivate extension Stop {
    static func from(_ stop: RawStop) -> Stop {
        let name = LocalizedText(en: stop.nameEN.capitalized,
                                 sc: stop.nameSC,
                                 tc: stop.nameTC)
        return Stop(
            id: String(stop.id),
            index: stop.index,
            name: name,
            lastUpdated: Date()
        )
    }
}

struct RawStop: Codable, Hashable, Identifiable {
    var id: Int
    var routeID: Int
    
    var direction: Int
    var index: Int
    
    var nameEN: String
    var nameSC: String
    var nameTC: String
    
    var lastUpdated: String
    
    var stop: Stop {
        Stop.from(self)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "STOP_ID"
        case routeID = "ROUTE_ID"
        case direction = "ROUTE_SEQ"
        case index = "STOP_SEQ"
        case nameEN = "STOP_NAMEE"
        case nameSC = "STOP_NAMES"
        case nameTC = "STOP_NAMEC"
        case lastUpdated = "LAST_UPDATE_DATE"
    }
}
