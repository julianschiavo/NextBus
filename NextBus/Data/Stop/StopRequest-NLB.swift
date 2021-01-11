//
//  NLB-StopRequest.swift
//  NextBus
//
//  Created by Julian Schiavo on 6/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

extension NLB {
    struct StopRequest: Encodable {
        var routeId: String
    }
}
