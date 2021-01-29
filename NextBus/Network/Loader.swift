//
//  Loader.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

enum SimpleKey: String, Codable, Identifiable {
    case all
    
    var id: String { rawValue }
}

/// A type that can load data from some source and throw errors
protocol Loader: ObservableObject, ThrowsErrors {
    associatedtype Key: Hashable
    associatedtype Object
    
    /// Creates a new instance of the loader
    init()
    
    /// The loaded object
    var object: Object? { get set }
    
    /// An ongoing request
    var cancellable: AnyCancellable? { get set }
    
    func load(key: Key)
    func createPublisher(key: Key) -> AnyPublisher<Object, Error>?
    func loadData(key: Key)
    func loadCompleted(key: Key, object: Object)
    func cancel()
}

extension Loader {
    func load(key: Key) {
        loadData(key: key)
    }

    func loadData(key: Key) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.cancellable = self.createPublisher(key: key)?
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    self?.catchCompletionError(completion)
                } receiveValue: { [weak self] object in
                    self?.object = object
                    self?.loadCompleted(key: key, object: object)
                }
        }
    }

    func loadCompleted(key: Key, object: Object) {

    }
    
    func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }
}

extension Loader where Key == SimpleKey {
    func load() {
        load(key: .all)
    }
}

protocol SimpleNetworkLoader: Loader {
    /// Creates a `URLRequest` for a network loading request
    func createRequest(for key: Key) -> URLRequest
    
    /// Decodes data received from network request into the object
    func decode(_ data: Data, key: Key) throws -> Object
}

extension SimpleNetworkLoader {
    func createPublisher(key: Key) -> AnyPublisher<Object, Error>? {
        let request = createRequest(for: key)
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .retry(3)
            .tryMap { data, response in
                try self.decode(data, key: key)
            }
            .eraseToAnyPublisher()
    }
}

protocol CachedLoader: Loader where Key == Cache.Key, Object == Cache.Value {
    associatedtype Cache: AnySingularCache
    var cache: Cache.Type { get }
}

extension CachedLoader {
    func load(key: Key) {
        loadCachedData(key: key)
        if cache.isValueStale(key) {
            loadData(key: key)
        }
    }
    
    private func loadCachedData(key: Key) {
        guard let object = cache[key] else { return }
        DispatchQueue.main.async {
            self.object = object
        }
    }
    
    func getCachedData(key: Key, completion: @escaping (Object?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            completion(self.cache[key])
        }
    }
    
    func loadCompleted(key: Key, object: Object) {
        cache[key] = object
    }
}

extension CachedLoader where Key == SimpleKey {
    func load() {
        load(key: .all)
    }
}
