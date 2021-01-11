//
//  GMB-Route.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

fileprivate extension Direction {
    static func from(_ direction: GMB._Route.Variant.Direction) -> Direction {
        switch direction {
        case .inbound: return .inbound
        case .outbound: return .outbound
        }
    }
}

fileprivate extension Route {
    static func from(_ route: GMB._Route) -> [Route] {
        let description = LocalizedText(en: route.descriptionEN,
                                        sc: route.descriptionSC,
                                        tc: route.descriptionTC)
        
        var routes = [Route]()
        for variant in route.variants {
            let origin = LocalizedText(en: variant.originEN,
                                       sc: variant.originSC,
                                       tc: variant.originTC)
            let destination = LocalizedText(en: variant.destinationEN,
                                            sc: variant.destinationSC,
                                            tc: variant.destinationTC)
            let direction = Direction.from(variant.direction)
            
            let variantRoute = Route(
                _id: String(route.id),
                companyID: .gmb,
                name: LocalizedText(""),
                description: description,
                category: .minibus,
                servicePeriod: .allDay,
                direction: direction,
                fare: 0,
                origin: origin,
                destination: destination,
                lastUpdated: route.generated
            )
            routes.append(variantRoute)
        }
        
        return routes
    }
}

extension GMB {
    enum Region: String, Codable {
        case hongKongIsland = "HKI"
        case kowloon = "KLN"
        case newTerritories = "NT"
    }
    
    struct RawUnknownRoute: Codable {
        var type: String
        var version: String
        var data: UnknownRegions
        var generated: Date
        
        enum CodingKeys: String, CodingKey {
            case type
            case version
            case data
            case generated = "generated_timestamp"
        }
        
        var routes: [UnknownRoute] {
            data.regions.routes
        }
    }
    
    struct UnknownRegions: Codable {
        struct Regions: Codable {
            var hongKongIsland: [String]
            var kowloon: [String]
            var newTerritories: [String]
            
            enum CodingKeys: String, CodingKey {
                case hongKongIsland = "HKI"
                case kowloon = "KLN"
                case newTerritories = "NT"
            }
            
            var routes: [UnknownRoute] {
                let hki = hongKongIsland.map { UnknownRoute(region: .hongKongIsland, name: $0) }
                let kln = kowloon.map { UnknownRoute(region: .kowloon, name: $0) }
                let nt = newTerritories.map { UnknownRoute(region: .newTerritories, name: $0) }
                return hki + kln + nt
            }
        }
        
        var regions: Regions
        var generated: Date
        
        enum CodingKeys: String, CodingKey {
            case regions = "routes"
            case generated = "data_timestamp"
        }
    }
    
    struct UnknownRoute: Codable {
        var region: Region
        var name: String
    }
    
    struct RawRoute: Codable {
        var type: String
        var version: String
        var data: [_Route]
        var generated: Date
        
        enum CodingKeys: String, CodingKey {
            case type
            case version
            case data
            case generated = "generated_timestamp"
        }
        
        var routes: [Route] {
            data.flatMap { Route.from($0) }
        }
    }
    
    struct _Route: Codable, Hashable {
        struct Variant: Codable, Hashable {
            enum Direction: Int, Codable, Hashable {
                case inbound = 1
                case outbound = 2
            }
            
            var direction: Direction
            
            var originEN: String
            var originSC: String
            var originTC: String
            
            var destinationEN: String
            var destinationSC: String
            var destinationTC: String
            
            var remarkEN: String?
            var remarkSC: String?
            var remarkTC: String?
            
            enum CodingKeys: String, CodingKey {
                case direction = "route_seq"
                case originEN = "orig_en"
                case originSC = "orig_sc"
                case originTC = "orig_tc"
                case destinationEN = "dest_en"
                case destinationSC = "dest_sc"
                case destinationTC = "dest_tc"
                case remarkEN = "remarks_en"
                case remarkSC = "remarks_sc"
                case remarkTC = "remarks_tc"
            }
        }
        
        var id: Int
        var variants: [Variant]
        
        var descriptionEN: String
        var descriptionSC: String
        var descriptionTC: String
        
        var generated: Date
        
        enum CodingKeys: String, CodingKey {
            case id = "route_id"
            case variants = "directions"
            case descriptionEN = "description_en"
            case descriptionSC = "description_sc"
            case descriptionTC = "description_tc"
            case generated = "data_timestamp"
        }
    }
}
