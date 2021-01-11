//
//  NLB-Route.swift
//  NextBus
//
//  Created by Julian Schiavo on 21/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

fileprivate extension Route {
    static func from(_ route: NLB._Route) -> Route {
        let name = LocalizedText(en: route.name, sc: route.name, tc: route.name)
        let origin = LocalizedText(en: route.originEN,
                                   sc: route.originSC,
                                   tc: route.originTC)
        let destination = LocalizedText(en: route.destinationEN,
                                        sc: route.destinationSC,
                                        tc: route.destinationTC)
        
        var servicePeriod = ServicePeriod.allDay
        if route.isSpecialRoute {
            servicePeriod = .special
        } else if route.isOvernightRoute {
            servicePeriod = .night
        }
        
        return Route(
            _id: route.id,
            companyID: .nlb,
            name: name,
            category: .bus,
            servicePeriod: servicePeriod,
            direction: .single,
            fare: 0,
            origin: origin,
            destination: destination,
            lastUpdated: Date()
        )
    }
}

extension NLB {
    struct RawRoute: Codable {
        var data: [_Route]
        
        enum CodingKeys: String, CodingKey {
            case data = "routes"
        }
        
        var routes: [Route] {
            data.map { Route.from($0) }
        }
    }

    struct _Route: Hashable, Codable {
        var id: String
        var name: String
        
        var isSpecialRouteInt: Int
        var isSpecialRoute: Bool { Bool(exactly: isSpecialRouteInt as NSNumber) ?? false }
        
        var isOvernightRouteInt: Int
        var isOvernightRoute: Bool { Bool(exactly: isOvernightRouteInt as NSNumber) ?? false }
        
        var fullNameEN: String
        var fullNameSC: String
        var fullNameTC: String
        
        var originEN: String {
            fullNameEN.components(separatedBy: " > ").first ?? fullNameEN
        }
        var originSC: String {
            fullNameSC.components(separatedBy: " > ").first ?? fullNameSC
        }
        var originTC: String {
            fullNameTC.components(separatedBy: " > ").first ?? fullNameTC
        }
        var destinationEN: String {
            fullNameEN.components(separatedBy: " > ").last ?? fullNameEN
        }
        var destinationSC: String {
            fullNameSC.components(separatedBy: " > ").last ?? fullNameSC
        }
        var destinationTC: String {
            fullNameTC.components(separatedBy: " > ").last ?? fullNameTC
        }
        
        enum CodingKeys: String, CodingKey {
            case id = "routeId"
            case name = "routeNo"
            case isSpecialRouteInt = "specialRoute"
            case isOvernightRouteInt = "overnightRoute"
            case fullNameEN = "routeName_e"
            case fullNameSC = "routeName_s"
            case fullNameTC = "routeName_c"
        }
    }
}
