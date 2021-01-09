//
//  Loadable.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

/// A `View` that loads content using a `Loader`
protocol Loadable: View {
    associatedtype Content: View
    associatedtype Loader: NextBus.Loader
    associatedtype Placeholder: View
    associatedtype Value
    
    typealias ValueKeyPath = KeyPath<Loader.Object, Value?>
    typealias LoaderView = Load<Loader, Value, Content, Placeholder>?
    
    /// The key identifying the object to load
    var key: Loader.Key { get }
    var keyPath: ValueKeyPath? { get }
    
    /// The loader to use to load content
    var loader: Loader { get }
    
    func placeholder() -> Placeholder
    
    /// Creates a view using loaded content
    /// - Parameter value: Loaded content
    func body(with value: Value) -> Content
}

extension Loadable {
    var keyPath: KeyPath<Loader.Object, Value?>? {
        nil
    }
    
    @ViewBuilder var loaderView: LoaderView {
        if let keyPath = keyPath {
            Load(with: loader, key: key, objectKeyPath: keyPath, content: body, placeholder: placeholder)
        }
    }
}

extension Loadable where Loader.Key == SimpleKey {
    var key: SimpleKey {
        .all
    }
    
    @ViewBuilder var loaderView: LoaderView {
        if let keyPath = keyPath {
            Load(with: loader, objectKeyPath: keyPath, content: body, placeholder: placeholder)
        }
    }
}

extension Loadable where Loader.Key == SimpleKey, Loader.Object == Value {
    @ViewBuilder var loaderView: LoaderView {
        Load(with: loader, content: body, placeholder: placeholder)
    }
}

extension Loadable where Loader.Object == Value {
    @ViewBuilder var loaderView: LoaderView {
        Load(with: loader, key: key, content: body, placeholder: placeholder)
    }
}
