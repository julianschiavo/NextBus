//
//  NWFBCTBRoute.swift
//  NextBus
//
//  Created by Julian Schiavo on 20/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

fileprivate extension Route {
    static func from(_ route: CTBNWFB._Route, generated: Date) -> [Route] {
        let name = LocalizedText(en: route.name,
                                 sc: route.name,
                                 tc: route.name)
        let origin = LocalizedText(en: route.originEN,
                                   sc: route.originSC,
                                   tc: route.originTC)
        let destination = LocalizedText(en: route.destinationEN,
                                   sc: route.destinationSC,
                                   tc: route.destinationTC)

        let outbound = Route(
            _id: route.name,
            companyID: route.companyID,
            name: name,
            category: .bus,
            servicePeriod: route.name.contains("N") ? .night : .allDay,
            direction: .outbound,
            fare: 0,
            origin: origin,
            destination: destination,
            lastUpdated: generated
        )
        
        var inbound = outbound
        inbound.direction = .inbound
        let iDestination = inbound.origin
        inbound.origin = inbound.destination
        inbound.destination = iDestination
        
        return [outbound, inbound]
    }
}

extension CTBNWFB {
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
            data.flatMap { Route.from($0, generated: generated) }
        }
    }

    struct _Route: Hashable, Codable {
        var companyID: CompanyID
        var name: String

        var originEN: String
        var originSC: String
        var originTC: String

        var destinationEN: String
        var destinationSC: String
        var destinationTC: String

        enum CodingKeys: String, CodingKey {
            case companyID = "co"
            case name = "route"
            case originEN = "orig_en"
            case originSC = "orig_sc"
            case originTC = "orig_tc"
            case destinationEN = "dest_en"
            case destinationSC = "dest_sc"
            case destinationTC = "dest_tc"
        }
    }
}
