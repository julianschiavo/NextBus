//
//  PublisherBuilder.swift
//  NextBus
//
//  Created by Julian Schiavo on 22/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

protocol PublisherBuilder: ObservableObject {
    associatedtype Key: Hashable
    associatedtype Object
    
    init(key: Key)
    func create() -> AnyPublisher<Object, Error>
}

protocol NetworkPublisherBuilder: PublisherBuilder {
    /// Creates a `URLRequest` for a network loading request
//    func createRequest(for key: Key) -> URLRequest
    
    /// Decodes data received from network request into the object
//    func decode(_ data: Data, key: Key) throws -> Object
}
