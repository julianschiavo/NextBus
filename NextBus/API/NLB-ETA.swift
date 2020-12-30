//
//  NLB-ETA.swift
//  NextBus
//
//  Created by Julian Schiavo on 23/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

struct NLBRawETA: Codable, Hashable {
    var rawETAs: [NLBETA]
    
    var rawMessage: String
    var message: String { rawMessage.replacingOccurrences(of: "<br />", with: "") }
    
    enum CodingKeys: String, CodingKey {
        case rawETAs = "estimatedArrivals"
        case rawMessage = "message"
    }
    
    func etas(for route: Route) -> OrderedSet<ETA> {
        OrderedSet(rawETAs.map { ETA(direction: .oneWay, date: $0.date, generated: $0.generated, englishDestination: route.englishDestination, simplifiedChineseDestination: route.simplifiedChineseDestination, traditionalChineseDestination: route.traditionalChineseDestination, englishRemark: $0.remark, simplifiedChineseRemark: $0.remark, traditionalChineseRemark: $0.remark, message: message) })
    }
}

struct NLBETA: Codable, Hashable {
    var date: Date
    
    var hasDepartedInt: Int
    var hasDeparted: Bool { Bool(exactly: hasDepartedInt as NSNumber) ?? false }
    
    var remark: String
    
    var generated: Date
    
    enum CodingKeys: String, CodingKey {
        case date = "estimatedArrivalTime"
        case hasDepartedInt = "departed"
        case remark = "routeVariantName"
        case generated = "generateTime"
    }
}
