//
//  NLB-Route.swift
//  NextBus
//
//  Created by Julian Schiavo on 21/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

fileprivate extension Route {
    static func from(_ route: NLBModels._Route) -> Route {
        let name = LocalizedText(en: route.name, sc: route.name, tc: route.name)
        let origin = LocalizedText(en: route.englishOrigin,
                                   sc: route.simplifiedChineseOrigin,
                                   tc: route.traditionalChineseOrigin)
        let destination = LocalizedText(en: route.englishDestination,
                                        sc: route.simplifiedChineseDestination,
                                        tc: route.traditionalChineseDestination)
        
        var servicePeriod = ServicePeriod.allDay
        if route.isSpecialRoute {
            servicePeriod = .special
        } else if route.isOvernightRoute {
            servicePeriod = .night
        }
        
        return Route(
            id: route.id,
            companyID: .nlb,
            name: name,
            category: .bus,
            servicePeriod: servicePeriod,
            direction: .single,
            fare: 0,
            origin: origin,
            destination: destination,
            lastUpdated: ""
        )
    }
}

extension NLBModels {
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
        
        var englishRouteName: String
        var simplifiedChineseRouteName: String
        var traditionalChineseRouteName: String
        
        var englishOrigin: String {
            englishRouteName.components(separatedBy: " > ").first ?? englishRouteName
        }
        var simplifiedChineseOrigin: String {
            simplifiedChineseRouteName.components(separatedBy: " > ").first ?? simplifiedChineseRouteName
        }
        var traditionalChineseOrigin: String {
            traditionalChineseRouteName.components(separatedBy: " > ").first ?? traditionalChineseRouteName
        }
        var englishDestination: String {
            englishRouteName.components(separatedBy: " > ").last ?? englishRouteName
        }
        var simplifiedChineseDestination: String {
            simplifiedChineseRouteName.components(separatedBy: " > ").last ?? simplifiedChineseRouteName
        }
        var traditionalChineseDestination: String {
            traditionalChineseRouteName.components(separatedBy: " > ").last ?? traditionalChineseRouteName
        }
        
        enum CodingKeys: String, CodingKey {
            case id = "routeId"
            case name = "routeNo"
            case isSpecialRouteInt = "specialRoute"
            case isOvernightRouteInt = "overnightRoute"
            case englishRouteName = "routeName_e"
            case simplifiedChineseRouteName = "routeName_s"
            case traditionalChineseRouteName = "routeName_c"
        }
    }
}
