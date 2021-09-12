//
//  SpecificLoader.swift
//  NextBus
//
//  Created by Julian Schiavo on 11/6/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

@MainActor
protocol SpecificLoader: ObservableObject {
    associatedtype Key: Hashable
    associatedtype Object
    
    init(key: Key)
    func load() async throws -> Object
}
