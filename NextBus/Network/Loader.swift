//
//  Loader.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

enum SimpleKey {
    case all
}

/// A type that can load data from some source and throw errors
protocol Loader: ObservableObject, ThrowsErrors {
    associatedtype Key: Hashable
    associatedtype Object
    
    /// Creates a new instance of the loader
    init()
    
    /// The loaded object
    var object: Object? { get set }
    
    func load(key: Key?)
    func loadData(key: Key)
    func loadCompleted(key: Key, object: Object)
    func cancel()
}

extension Loader {
    func prepare() {
        cancel()
    }
    
    func loadCompleted(key: Key, object: Object) {
        
    }
}

extension Loader where Key == SimpleKey {
    func load() {
        load(key: .all)
    }
}

protocol NetworkLoader: Loader {
    /// An ongoing request
    var cancellable: AnyCancellable? { get set }
    
    /// Creates a `URLRequest` for a network loading request
    func createRequest(for key: Key) -> URLRequest
    
    /// Decodes data received from network request into the object
    func decode(_ data: Data, key: Key) throws -> Object
}

extension NetworkLoader {
    func load(key: Key?) {
        guard let key = key else {
            if let simpleKey = SimpleKey.all as? Key {
                load(key: simpleKey)
            }
            return
        }
        if key.hashValue == ModelID<Any>.placeholder.hashValue {
            return
        }
        prepare()
        loadData(key: key)
    }
    
    func loadData(key: Key) {
        let request = createRequest(for: key)
        
        cancellable = URLSession.shared
            .dataTaskPublisher(for: request)
            .retry(3)
            .tryMap { data, response in
                try self.decode(data, key: key)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.catchCompletionError(completion)
            } receiveValue: { [weak self] object in
                self?.object = object
            }
    }
}

//extension NetworkLoader where Object == Decodable {
//    func decode(_ data: Data, key: Key) throws -> Object {
//        let decoder = JSONDecoder()
//        return try decoder.decode(Object.self, from: data)
//    }
//}

protocol CachedNetworkLoader: NetworkLoader where Key == Cache.Key, Object == Cache.Value {
    associatedtype Cache: SharedCache
    var cache: Cache.Type { get }
}

extension CachedNetworkLoader {
    func load(key: Key?) {
        guard let key = key else {
            if let simpleKey = SimpleKey.all as? Key {
                load(key: simpleKey)
            }
            return
        }
        if key.hashValue == ModelID<Any>.placeholder.hashValue {
            return
        }
        prepare()
        loadCachedData(key: key)
        if cache.isStale(key) {
            loadData(key: key)
        }
    }
    
    private func loadCachedData(key: Key) {
        guard let object = cache[key] else { return }
        self.object = object
    }
    
    func loadCompleted(key: Key, object: Object) {
        cache[key] = object
    }
}
