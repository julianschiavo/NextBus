//
//  ETARequest.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

struct ETARequest: Hashable {
    var route: Route
    var stop: Stop
}
