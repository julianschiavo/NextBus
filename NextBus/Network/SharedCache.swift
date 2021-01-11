//
//  SharedCache.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation

protocol SharedCache {
    associatedtype Key: Hashable & Identifiable
    associatedtype Value
    
    static var shared: Cache<Key, Value> { get }
    static subscript(key: Key) -> Value? { get set }
    static func isStale(_ key: Key) -> Bool
}

extension SharedCache {
    static subscript(key: Key) -> Value? {
        get {
            shared[key]
        }
        set {
            shared[key] = newValue
        }
    }
    
    static func isStale(_ key: Key) -> Bool {
        shared.isStale(key)
    }
}
