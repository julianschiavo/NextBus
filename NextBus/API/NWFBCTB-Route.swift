//
//  NWFBCTBRoute.swift
//  NextBus
//
//  Created by Julian Schiavo on 20/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

struct NWFBCTBRawRoute: Codable {
    var type: String
    var version: String
    var data: [NWFBCTBRoute]
    var generated: Date
    
    enum CodingKeys: String, CodingKey {
        case type
        case version
        case data
        case generated = "generated_timestamp "
    }
    
    var routes: OrderedSet<Route> {
        OrderedSet(data.map { Route(companyID: $0.companyID, id: $0.name, name: $0.name, isOneWay: false, isSpecial: false, isOvernight: false, generated: generated, englishOrigin: $0.englishOrigin, simplifiedChineseOrigin: $0.simplifiedChineseOrigin, traditionalChineseOrigin: $0.traditionalChineseOrigin, englishDestination: $0.englishDestination, simplifiedChineseDestination: $0.simplifiedChineseDestination, traditionalChineseDestination: $0.traditionalChineseDestination) })
    }
}

struct NWFBCTBRoute: Hashable, Codable {
    var companyID: CompanyID
    var name: String
    
    var englishOrigin: String
    var simplifiedChineseOrigin: String
    var traditionalChineseOrigin: String
    
    var englishDestination: String
    var simplifiedChineseDestination: String
    var traditionalChineseDestination: String
    
    enum CodingKeys: String, CodingKey {
        case companyID = "co"
        case name = "route"
        case englishOrigin = "orig_en"
        case simplifiedChineseOrigin = "orig_sc"
        case traditionalChineseOrigin = "orig_tc"
        case englishDestination = "dest_en"
        case simplifiedChineseDestination = "dest_sc"
        case traditionalChineseDestination = "dest_tc"
    }
}
