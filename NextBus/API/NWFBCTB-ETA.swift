//
//  NWFBCTBETA.swift
//  NextBus
//
//  Created by Julian Schiavo on 20/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

struct NWFBCTBRawETA: Codable, Hashable {
    var type: String
    var version: String
    var data: [NWFBCTBETA]
    
    func etas(for direction: Direction) -> OrderedSet<ETA> {
        let newData = data
            .filter { $0.direction.direction == direction }
            .map { ETA(direction: $0.direction.direction, index: $0.index, date: $0.date, generated: $0.generated, englishDestination: $0.englishDestination, simplifiedChineseDestination: $0.simplifiedChineseDestination, traditionalChineseDestination: $0.traditionalChineseDestination, englishRemark: $0.englishRemark, simplifiedChineseRemark: $0.simplifiedChineseRemark, traditionalChineseRemark: $0.traditionalChineseRemark) }
        return OrderedSet(newData)
    }
}

struct NWFBCTBETA: Codable, Hashable {
    var direction: NWFBCTBDirection
    
    var index: Int
    var dateString: String
    var date: Date? {
        let iso8601DateFormatter = ISO8601DateFormatter()
        return iso8601DateFormatter.date(from: dateString)
    }
    
    var generated: Date
    
    var englishDestination: String
    var simplifiedChineseDestination: String
    var traditionalChineseDestination: String
    
    var englishRemark: String
    var simplifiedChineseRemark: String
    var traditionalChineseRemark: String
    
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
