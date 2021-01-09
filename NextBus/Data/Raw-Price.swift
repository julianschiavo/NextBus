//
//  Raw-Price.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation

enum RawValue: Codable {
    case int(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else {
            throw DecodingError.typeMismatch(RawValue.self, .init(codingPath: decoder.codingPath, debugDescription: "Expected to decode String or Int but found another type instead."))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .int(value):
            try container.encode(value)
        case let .string(value):
            try container.encode(value)
        }
    }
}

struct RawPriceData: Decodable {
    var header: [String]
    var rows: [[RawValue]]
    
    private func convertToDictionary() -> [[String: RawValue]] {
        var list = [[String: RawValue]]()
        for row in rows {
            var dict = [String: RawValue]()
            for (i, column) in header.enumerated() {
                dict[column] = row[i]
            }
            list.append(dict)
        }
        return list
    }
    
    func convertToPriceData() -> [PriceData] {
        let dict = convertToDictionary()
        
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(dict) else { return [] }
        
        let decoder = JSONDecoder()
        guard let priceData = try? decoder.decode([PriceData].self, from: data) else { return [] }
        return priceData
    }
}

struct PriceData: Codable {
    var routeID: Int
    var companyID: String
    var district: String
    
    var englishRouteName: String
    var simplifiedChineseRouteName: String
    var traditionalChineseRouteName: String
    
    var routeType: Int
    var serviceMode: String
    var specialType: Int
    var journeyTime: Int
    
    var englishOrigin: String
    var simplifiedChineseOrigin: String
    var traditionalChineseOrigin: String
    
    var englishDestination: String
    var simplifiedChineseDestination: String
    var traditionalChineseDestination: String
    
    var englishURL: String
    var simplifiedChineseURL: String
    var traditionalChineseURL: String
    
    var fullFare: String
    
    var lastUpdateDate: String
    
    enum CodingKeys: String, CodingKey {
        case routeID = "ROUTE_ID"
        case companyID = "COMPANY_CODE"
        case district = "DISTRICT"
        
        case englishRouteName = "ROUTE_NAMEE"
        case simplifiedChineseRouteName = "ROUTE_NAMES"
        case traditionalChineseRouteName = "ROUTE_NAMEC"
        
        case routeType = "ROUTE_TYPE"
        case serviceMode = "SERVICE_MODE"
        case specialType = "SPECIAL_TYPE"
        case journeyTime = "JOURNEY_TIME"
        
        case englishOrigin = "LOC_START_NAMEE"
        case simplifiedChineseOrigin = "LOC_START_NAMES"
        case traditionalChineseOrigin = "LOC_START_NAMEC"
        
        case englishDestination = "LOC_END_NAMEE"
        case simplifiedChineseDestination = "LOC_END_NAMES"
        case traditionalChineseDestination = "LOC_END_NAMEC"
        
        case englishURL = "HYPERLINK_E"
        case simplifiedChineseURL = "HYPERLINK_S"
        case traditionalChineseURL = "HYPERLINK_C"
        
        case fullFare = "FULL_FARE"
        
        case lastUpdateDate = "LAST_UPDATE_DATE"
    }
}
