//
//  NLB-StopRequest.swift
//  NextBus
//
//  Created by Julian Schiavo on 6/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

extension NLBModels {
    struct StopRequest: Encodable {
        var routeId: String
    }
}
