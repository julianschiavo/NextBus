//
//  Cache.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation

// Adapted From https://www.swiftbysundell.com/articles/caching-in-swift/
class Cache<Key: Hashable & Identifiable, Value>: HasLogger {
    
    private var lastUpdateDictionary = [Key: Date]()
    
    final private func keyObject(_ key: Key) -> WrappedKey {
        wrap(key.id)
    }
    
    final func insert(_ value: Value, forKey key: Key) {
        _cache.setObject(wrap(value), forKey: keyObject(key))
    }
    
    final func value(forKey key: Key) -> Value? {
        _cache.object(forKey: keyObject(key))?.value
    }
    
    final func removeValue(forKey key: Key) {
        _cache.removeObject(forKey: keyObject(key))
    }
    
    final subscript(key: Key) -> Value? {
        get {
            if let value = value(forKey: key) {
                logEvent(named: "Served", key: key.id)
                return value
            } else {
                logEvent(named: "Missed", key: key.id)
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
            
            logEvent(named: "Update", key: key.id)
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
        logEvent(named: isStale ? "Staled" : "Fresh", key: key.id)
        return isStale
    }
    
    // MARK: - NSCache Wrapping
    
    private final let _cache = NSCache<WrappedKey, WrappedValue>()
    
    private final class WrappedKey: NSObject {
        let key: Key.ID

        init(_ key: Key.ID) {
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
    
    private final func wrap(_ key: Key.ID) -> WrappedKey {
        WrappedKey(key)
    }
    
    private final func wrap(_ value: Value) -> WrappedValue {
        WrappedValue(value)
    }
    
    // MARK: - Logging
    
    static var category: String { "Cache" }
    
    private func logEvent(named eventName: String, key: Key.ID) {
        logger.info("\(eventName, align: .left(columns: 7), privacy: .public) \(Value.self, align: .left(columns: 25), privacy: .public) ID: \(String(describing: key), privacy: .private(mask: .hash))")
    }
}
