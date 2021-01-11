//
//  ETA.swift
//  NextBus
//
//  Created by Julian Schiavo on 19/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation
import Intents

struct ETA: Codable, Hashable, Identifiable {
    var id: String?

    var date: Date?
    var generated: Date
    
    /// A remark or note related to the ETA, such as a special route note
    var remark: LocalizedText
    var localizedRemark: String {
        remark.current
    }
    
    /// A message related to the ETA, such as the accuracy of the estimation
    var message: String?
    
    static func unknown(for route: Route) -> ETA {
        ETA(
            generated: Date(),
            remark: LocalizedText("")
        )
    }
    
    // MARK: - Intents
    
//    var intentObject: INETA {
//        let dateFormatter = RelativeDateTimeFormatter()
//        let formattedDate = dateFormatter.string(for: date) ?? ""
//        let object = INETA(identifier: nil, display: "Arriving \(formattedDate)")
//
//        if let date = date {
//            object.arrivalDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//        }
//
//        object.direction = direction.intentObject
//        object.index = (index ?? 0) as NSNumber
//        object.destination = destination
//        object.remark = remark
//        object.message = message
//        object.generated = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: generated)
//        return object
//    }
}
