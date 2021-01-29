//
//  SingularCache.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation

protocol AnySingularCache {
    associatedtype Key: Hashable & Identifiable
    associatedtype Value
    
    static subscript(key: Key) -> Value? { get set }
    static func isValueStale(_ key: Key) -> Bool
}

protocol SingularCache: AnySingularCache {
    static var shared: Cache<Key, Value> { get }
}

extension SingularCache {
    static subscript(key: Key) -> Value? {
        get {
            shared[key]
        }
        set {
            shared[key] = newValue
        }
    }
    
    static func isValueStale(_ key: Key) -> Bool {
        shared.isValueStale(forKey: key)
    }
}

protocol SerializableSingularCache: AnySingularCache where Key: Codable, Value: Codable {
    static var shared: SerializableCache<Key, Value> { get }
}

extension SerializableSingularCache {
    static subscript(key: Key) -> Value? {
        get {
            shared[key]
        }
        set {
            shared[key] = newValue
        }
    }
    
    static func isValueStale(_ key: Key) -> Bool {
        shared.isValueStale(forKey: key)
    }
}
