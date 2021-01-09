//
//  Cache.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation

// Adapted From https://www.swiftbysundell.com/articles/caching-in-swift/
class Cache<Key: Hashable, Value>: HasLogger {
    
    private var lastUpdateDictionary = [Key: Date]()
    
    final func insert(_ value: Value, forKey key: Key) {
        _cache.setObject(wrap(value), forKey: wrap(key))
    }
    
    final func value(forKey key: Key) -> Value? {
        _cache.object(forKey: wrap(key))?.value
    }
    
    final func removeValue(forKey key: Key) {
        _cache.removeObject(forKey: wrap(key))
    }
    
    final subscript(key: Key) -> Value? {
        get {
            if let value = value(forKey: key) {
                logEvent(named: "Served", key: key)
                return value
            } else {
                logEvent(named: "Missed", key: key)
                return nil
            }
        }
        set {
            guard let value = newValue else {
                // If nil was assigned using our subscript,
                // then we remove any value for that key:
                removeValue(forKey: key)
                lastUpdateDictionary.removeValue(forKey: key)
                return
            }
            
            logEvent(named: "Update", key: key)
            insert(value, forKey: key)
            lastUpdateDictionary[key] = Date()
        }
    }
    
    final func isStale(_ key: Key) -> Bool {
        guard let lastUpdate = lastUpdateDictionary[key] else { return true }
        let now = Date()
        let expirationDate = lastUpdate.addingTimeInterval(600)
        let range = lastUpdate...expirationDate
        let isStale = !range.contains(now)
        logEvent(named: isStale ? "Staled" : "Fresh", key: key)
        return isStale
    }
    
    // MARK: - NSCache Wrapping
    
    private final let _cache = NSCache<WrappedKey, WrappedValue>()
    
    private final class WrappedKey: NSObject {
        let key: Key
        
        init(_ key: Key) {
            self.key = key
        }
        
        override var hash: Int {
            key.hashValue
        }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? Self else { return false }
            return value.key == key
        }
    }
    
    private final class WrappedValue {
        let value: Value
        
        init(_ value: Value) {
            self.value = value
        }
    }
    
    private final func wrap(_ key: Key) -> WrappedKey {
        WrappedKey(key)
    }
    
    private final func wrap(_ value: Value) -> WrappedValue {
        WrappedValue(value)
    }
    
    // MARK: - Logging
    
    static var category: String { "Cache" }
    
    private func logEvent(named eventName: String, key: Key) {
        logger.info("\(eventName, align: .left(columns: 7), privacy: .public) \(Value.self, align: .left(columns: 25), privacy: .public) ID: \(String(describing: key), privacy: .private(mask: .hash))")
    }
}
