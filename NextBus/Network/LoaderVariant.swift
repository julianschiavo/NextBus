//
//  LoaderVariant.swift
//  NextBus
//
//  Created by Julian Schiavo on 10/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

/// A type that can load data from some source and throw errors
protocol LoaderVariant: ObservableObject, ThrowsErrors {
    associatedtype Key: Hashable
    associatedtype Object
    
    init(key: Key)
    
    var object: Object? { get set }
    
    func load()
    func cancel()
}
