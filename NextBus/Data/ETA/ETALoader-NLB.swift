//
//  ETALoader-NLB.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

typealias GenericETARequest = ETARequest

extension NLB {
    class ETALoader: ETALoaderVariant {
        private let request: GenericETARequest
        
        required init(key: GenericETARequest) {
            self.request = key
            super.init(key: key)
        }
        
        override func createRequest() -> URLRequest {
            let initialURL = NLB.baseURL.appendingPathComponent("stop.php")
            
            var components = URLComponents(url: initialURL, resolvingAgainstBaseURL: false)
            components?.queryItems = [URLQueryItem(name: "action", value: "estimatedArrivals")]
            
            guard let url = components?.url else { fatalError("Invalid URLComponents Object") }
            
            let requestData = NLB.ETARequest(routeId: request.route._id, stopId: request.stop.id)
            return .postRequest(url: url, body: requestData)
        }
        
        override func decode(_ data: Data) throws -> [ETA] {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(.dateSpaceTime)
            
            let rawETA = try decoder.decode(NLB.RawETA.self, from: data)
            let etas = rawETA.etas(for: request.route)
            return Array(etas)
        }
    }
}
