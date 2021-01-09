//
//  NWFBCTBRoute.swift
//  NextBus
//
//  Created by Julian Schiavo on 20/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

fileprivate extension Route {
    static func from(_ route: NWFBCTBModels._Route, generated: Date) -> Route {
        let name = LocalizedText(en: route.name, sc: route.name, tc: route.name)
        let origin = LocalizedText(en: route.englishOrigin,
                                   sc: route.simplifiedChineseOrigin,
                                   tc: route.traditionalChineseOrigin)
        let destination = LocalizedText(en: route.englishDestination,
                                   sc: route.simplifiedChineseDestination,
                                   tc: route.traditionalChineseDestination)

        return Route(
            id: route.name,
            companyID: route.companyID,
            name: name,
            category: .bus,
            servicePeriod: route.name.contains("N") ? .night : .allDay,
            direction: .outbound,
            fare: 0,
            origin: origin,
            destination: destination,
            lastUpdated: ""
        )
    }
}

extension NWFBCTBModels {
    struct RawRoute: Codable {
        var type: String
        var version: String
        var data: [_Route]
        var generated: Date

        enum CodingKeys: String, CodingKey {
            case type
            case version
            case data
            case generated = "generated_timestamp "
        }

        var routes: [Route] {
            data.map { Route.from($0, generated: generated) }
        }
    }

    struct _Route: Hashable, Codable {
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
}
