//
//  ETA-KMB.swift
//  NextBus
//
//  Created by Julian Schiavo on 11/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

extension ETA {
    static func from(_ eta: KMB._ETA) -> ETA {
        return ETA(
            id: UUID().uuidString,
            date: eta.date,
            generated: Date(),
            remark: LocalizedText(eta.remark ?? "")
        )
    }
}

extension KMB {
    struct _ETA: Codable, Hashable {
        var date: Date
        var remark: String?
    }
}
