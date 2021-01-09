//
//  NLB-ETARequest.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation

extension NLBModels {
    struct ETARequest: Encodable {
        var routeId: String
        var stopId: String
        let language: String = LocalizedText.nlbLanguageCode
    }
}
