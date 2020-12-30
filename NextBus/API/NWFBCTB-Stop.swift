//
//  NWFBCTBStop.swift
//  NextBus
//
//  Created by Julian Schiavo on 20/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

enum NWFBCTBDirection: String, Codable, Hashable {
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
    
    static func from(_ direction: Direction) -> NWFBCTBDirection {
        switch direction {
        case .oneWay: fatalError("NWFBCTBDirection does not support one way routes")
        case .inbound: return self.inbound
        case .outbound: return self.outbound
        }
    }
}

struct NWFBCTBRawUnknownStop: Codable, Hashable {
    var type: String
    var version: String
    var data: [NWFBCTBUnknownStop]
    var generated: Date
    
    enum CodingKeys: String, CodingKey {
        case type
        case version
        case data
        case generated = "generated_timestamp "
    }
    
    var unknownStops: OrderedSet<NWFBCTBUnknownStop> {
        let newData: [NWFBCTBUnknownStop] = data.map {
            var newItem = $0
            newItem.generated = generated
            return newItem
        }
        return OrderedSet(newData)
    }
}

struct NWFBCTBUnknownStop: Codable, Hashable {
    var id: String
    var index: Int
    var generated: Date
    
    var companyID: String
    var route: String
    var direction: NWFBCTBDirection
    
    enum CodingKeys: String, CodingKey {
        case id = "stop"
        case index = "seq"
        case generated = "data_timestamp"
        case companyID = "co"
        case route = "route"
        case direction = "dir"
    }
}

struct NWFBCTBRawStop: Codable, Hashable {
    var type: String
    var version: String
    var data: NWFBCTBStop
    var generated: Date
    
    enum CodingKeys: String, CodingKey {
        case type
        case version
        case data
        case generated = "generated_timestamp "
    }
    
    var stop: Stop {
        Stop(id: data.id, index: 0, generated: generated, englishName: data.englishName, simplifiedChineseName: data.simplifiedChineseName, traditionalChineseName: data.traditionalChineseName, latitude: data.latitude, longitude: data.longitude)
    }
}

struct NWFBCTBStop: Codable, Hashable {
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
