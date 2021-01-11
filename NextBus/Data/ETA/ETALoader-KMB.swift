//
//  ETALoader-KMB.swift
//  NextBus
//
//  Created by Julian Schiavo on 11/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

extension KMB {
    class ETALoader: ETALoaderVariant {
        private let request: ETARequest
        
        required init(key: ETARequest) {
            self.request = key
            super.init(key: key)
        }
        
        override func createRequest() -> URLRequest {
            let url = baseURL
                .appendingPathComponent("kmb")
                .appendingPathComponent("eta")
                .appendingPathComponent(LocalizedText.kmbLanguageCode)
                .appendingPathComponent(request.route.localizedName)
                .appendingPathComponent(request.route.direction.sequence)
                .appendingPathComponent(String(request.stop.index))
            print(url)
            return URLRequest(url: url)
        }
        
        override func decode(_ data: Data) throws -> [ETA] {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601FractionalSeconds
            let rawETA = try decoder.decode([_ETA].self, from: data)
            return rawETA.map { ETA.from($0) }
        }
    }
}
