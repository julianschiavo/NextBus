//
//  Cache.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation

// Adapted From https://www.swiftbysundell.com/articles/caching-in-swift/
class Cache<Key: Hashable & Identifiable, Value> {
    
    /// Whether the cache automatically removes stale items.
    final let autoRemoveStaleItems: Bool
    
    /// The wrapped `NSCache`.
    final let _cache = NSCache<_Key, _Entry>()
    
    // MARK: - Public
    
    /// Creates a new `Cache`
    /// - Parameter autoRemoveStaleItems: Whether to automatically remove stale items, `false` by default.
    init(shouldAutomaticallyRemoveStaleItems autoRemoveStaleItems: Bool = false) {
        self.autoRemoveStaleItems = autoRemoveStaleItems
    }
    
    /// Accesses the value associated with the given key for reading and writing. When you assign a value for a key and that key already exists, the cache overwrites the existing value. If the cache doesn’t contain the key, the key and value are added as a new key-value pair. If you assign `nil` as the value for the given key, the cache removes that key and its associated value.
    final subscript(key: Key) -> Value? {
        get {
            value(for: key)
        }
        set {
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }
            
            updateValue(value, forKey: key)
        }
    }
    
    /// Whether the value associated with the `key` is stale. Returns `true` if the key is not in the cache.
    /// - Parameter key: The key to find in the cache.
    /// - Returns: Whether the value associated with the `key` is stale.
    final func isValueStale(forKey key: Key) -> Bool {
        guard let value = entry(for: key) else {
            return true
        }
        
        return Date() > value.expirationDate
    }
    
    // MARK: - Internal
    
    /// Accesses the value associated with the given key.
    /// - Parameter key: The key to find in the cache.
    /// - Returns: The value associated with `key` if `key` is in the cache; otherwise, `nil`.
    final func value(for key: Key) -> Value? {
        entry(for: key)?.value
    }
    
    /// Accesses the entry associated with the given key.
    /// - Parameter key: The key to find in the cache.
    /// - Returns: The entry associated with `key` if `key` is in the cache; otherwise, `nil`.
    final func entry(for key: Key) -> _Entry? {
        let key = _Key(key)
        return entry(for: key)
    }
    
    /// Accesses the entry associated with the given key.
    /// - Parameter key: The key to find in the cache.
    /// - Returns: The entry associated with `key` if `key` is in the cache; otherwise, `nil`.
    private final func entry(for key: _Key) -> _Entry? {
        _cache.object(forKey: key)
    }
    
    /// Updates the cached value for the given key, or adds the key-value pair to the cache if the key does not exist.
    /// - Parameters:
    ///   - value: The new value to add to the cache.
    ///   - key: The key to associate with `value`. If `key` already exists in the cache, `value` replaces the existing associated value. If `key` isn’t already a key of the cache, the (`key`, `value`) pair is added.
    final func updateValue(_ value: Value, forKey key: Key) {
        let _key = _Key(key)
        let entry = _Entry(key: key, value: value)
        updateEntry(entry, forKey: _key)
    }
    
    /// Updates the cached entry for the given key, or adds the entry to the cache if the key does not exist.
    /// - Parameters:
    ///   - entry: The entry to add to the cache.
    ///   - key: The key to associate with `entry`. If `key` already exists in the cache, `entry` replaces the existing entry. If `key` isn’t already a key of the cache, the entry is added.
    func updateEntry(_ entry: _Entry, forKey key: _Key) {
        _cache.setObject(entry, forKey: key)
    }
    
    /// Removes the given key and its associated value from the cache.
    /// - Parameter key: The key to remove along with its associated value.
    private final func removeValue(forKey key: Key) {
        let key = _Key(key)
        removeValue(forKey: key)
    }
    
    /// Removes the given key and its associated value from the cache.
    /// - Parameter key: The key to remove along with its associated value.
    private final func removeValue(forKey key: _Key) {
        _cache.removeObject(forKey: key)
    }
    
    /// Empties the cache.
    private final func removeAll() {
        _cache.removeAllObjects()
    }
    
    // MARK: - Wrapped Classes
    
    /// A wrapper for a `Key`
    final class _Key: NSObject {
        /// The wrapped `Key`
        let key: Key.ID
        
        /// Creates a new wrapper for a key.
        /// - Parameter key: The key to wrap
        init(_ key: Key) {
            self.key = key.id
        }

        override var hash: Int {
            key.hashValue
        }

        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? Self else { return false }
            return value.key == key
        }
    }
    
    /// A wrapper for a key-value pair.
    final class _Entry {
        /// The key
        let key: Key
        
        /// The value
        let value: Value
        
        /// The expiration date of the object
        let expirationDate: Date
        
        /// Creates a new wrapper for a key-value pair.
        /// - Parameters:
        ///   - key: The key
        ///   - value: The value
        init(key: Key, value: Value) {
            self.key = key
            self.value = value
            self.expirationDate = Date().addingTimeInterval(3600)
        }
    }
}

final class SerializableCache<Key: Codable & Hashable & Identifiable, Value: Codable>: Cache<Key, Value>, Codable {
    /// The unique name for the cache
    final var name: String
    
    /// A ledger of keys stored in the cache, used when serializing data to disk.
    private final let keyLedger = KeyLedger()
    
    /// Creates a new `Cache`
    /// - Parameter autoRemoveStaleItems: Whether to automatically remove stale items, `false` by default.
    init(name: String, shouldAutomaticallyRemoveStaleItems autoRemoveStaleItems: Bool = false) {
        self.name = name
        super.init(shouldAutomaticallyRemoveStaleItems: autoRemoveStaleItems)
        
        _cache.delegate = keyLedger
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init(name: "")
        let container = try decoder.singleValueContainer()
        let entries = try container.decode([_Entry].self)
        entries.forEach { updateValue($0.value, forKey: $0.key) } // TODO: keep expiration date?
    }
    
    // MARK: - Codable
    
    func encode(to encoder: Encoder) throws {
        let entries = keyLedger.keys.compactMap(entry)
        var container = encoder.singleValueContainer()
        try container.encode(entries)
    }
    
    func save() {
        guard !name.isEmpty else { return }
        let fileURL = Store.appGroupFolderURL.appendingPathComponent(self.name + ".cache")

        DispatchQueue.global(qos: .default).async {
            do {
                let data = try JSONEncoder().encode(self)
                print("[Cache] Saving \(self.name) data:", data.count)
                try data.write(to: fileURL)
            } catch {
                print("SAVING ERROR", error)
            }
        }
    }
    
    static func load(name: String, shouldAutomaticallyRemoveStaleItems: Bool = false) -> SerializableCache<Key, Value> {
        let empty = SerializableCache(name: name, shouldAutomaticallyRemoveStaleItems: shouldAutomaticallyRemoveStaleItems)
        do {
            let fileURL = Store.appGroupFolderURL.appendingPathComponent(name + ".cache")
            let data = try Data(contentsOf: fileURL)
            print("[Cache] Loading \(name) data:", data.count)
            let cache = try JSONDecoder().decode(self, from: data)
            cache.name = name // setting after decoding avoids re-saving cache to disk unnescessarily
            return cache
        } catch {
            print("LOAD", "error", error)
            return empty
        }
    }
    
    // MARK: - Internal
    
    /// Updates the cached entry for the given key, or adds the entry to the cache if the key does not exist.
    /// - Parameters:
    ///   - entry: The entry to add to the cache.
    ///   - key: The key to associate with `entry`. If `key` already exists in the cache, `entry` replaces the existing entry. If `key` isn’t already a key of the cache, the entry is added.
    override func updateEntry(_ entry: _Entry, forKey key: _Key) {
        _cache.setObject(entry, forKey: key)
        keyLedger.insert(entry.key, to: self)
    }
    
    /// A ledger that stores a list of keys, conforming to `NSCacheDelegate` to automatically remove evicted keys.
    final class KeyLedger: NSObject, NSCacheDelegate {
        /// The list of keys.
        private(set) var keys = Set<Key>()
        
        func insert(_ key: Key, to cache: SerializableCache<Key, Value>) {
            if keys.insert(key).inserted {
                cache.save()
            }
        }
        
        func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject object: Any) {
            guard let entry = object as? _Entry else { return }
            keys.remove(entry.key)
        }
    }
}

extension Cache._Entry: Codable where Key: Codable, Value: Codable {}
