//
//  ETALoader-GMB.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

extension GMB {
    class ETALoader: ETALoaderVariant {
        private let request: ETARequest
        
        required init(key: ETARequest) {
            self.request = key
            super.init(key: key)
        }
        
        override func createRequest() -> URLRequest {
            let url = baseURL
                .appendingPathComponent("eta")
                .appendingPathComponent("route-stop")
                .appendingPathComponent(request.route._id)
                .appendingPathComponent(request.route.direction.sequence)
                .appendingPathComponent(String(request.stop.index))
            return URLRequest(url: url)
        }
        
        override func decode(_ data: Data) throws -> [ETA] {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601FractionalSeconds
            let rawETA = try decoder.decode(RawETA.self, from: data)
            return rawETA.etas
        }
    }
}
