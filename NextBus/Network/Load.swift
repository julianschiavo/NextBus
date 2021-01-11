//
//  Load.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import SwiftUI

typealias GenericLoader = Loader

/// A view that loads content using a `Loader` before displaying the content using a custom `View`
struct Load<Loader: GenericLoader, Value, Content: View, PlaceholderContent: View>: View {
    
    /// The loader sub
    @ObservedObject private var loader: Loader
    
    /// The key identifying the object to load
    private let key: Loader.Key
    
    private var keyPath: KeyPath<Loader.Object, Value?>?
    
    /// Builds a view using a loaded object
    private var contentBuilder: (Value) -> Content
    
    /// Builds a placeholder for the content
    private var placeholderContentBuilder: () -> PlaceholderContent
    
    /// The loaded object, if it loaded
    private var value: Value? {
        guard let object = loader.object else { return nil }
        if let keyPath = keyPath {
            return object[keyPath: keyPath]
        } else {
            return object as? Value
        }
    }
    
    init(with loader: Loader,
         key: Loader.Key,
         objectKeyPath: KeyPath<Loader.Object, Value?>,
         @ViewBuilder content contentBuilder: @escaping (Value) -> Content,
         @ViewBuilder placeholder placeholderContentBuilder: @escaping () -> PlaceholderContent) {
        
        self.loader = loader
        self.key = key
        self.keyPath = objectKeyPath
        self.placeholderContentBuilder = placeholderContentBuilder
        self.contentBuilder = contentBuilder
    }
    
    init<P: HasPlaceholder>(with loader: Loader,
                            key: Loader.Key,
                            objectKeyPath: KeyPath<Loader.Object, Value?>,
                            placeholderView: P.Type,
                            @ViewBuilder content contentBuilder: @escaping (Value) -> Content) where PlaceholderContent == P.Placeholder {
        
        self.loader = loader
        self.key = key
        self.keyPath = objectKeyPath
        self.contentBuilder = contentBuilder
        self.placeholderContentBuilder = {
            placeholderView.placeholder
        }
    }
    
    var body: some View {
        bodyContent
            .alert(errorBinding: $loader.error)
            .onAppear {
                loader.load(key: key)
            }
            .onDisappear {
                loader.cancel()
            }
    }
    
    @ViewBuilder private var bodyContent: some View {
        if let value = value {
            contentBuilder(value)
        } else {
            placeholderContent
        }
    }
    
    private var placeholderContent: some View {
        placeholderContentBuilder()
    }
}

// No Key
extension Load where Loader.Key == SimpleKey {
    init(with loader: Loader,
         objectKeyPath: KeyPath<Loader.Object, Value?>,
         @ViewBuilder content contentBuilder: @escaping (Value) -> Content,
         @ViewBuilder placeholder placeholderContentBuilder: @escaping () -> PlaceholderContent) {
        
        self.loader = loader
        self.key = .all
        self.keyPath = objectKeyPath
        self.placeholderContentBuilder = placeholderContentBuilder
        self.contentBuilder = contentBuilder
    }
    
    init<P: HasPlaceholder>(with loader: Loader,
                            objectKeyPath: KeyPath<Loader.Object, Value?>,
                            placeholderView: P.Type,
                            @ViewBuilder content contentBuilder: @escaping (Value) -> Content) where PlaceholderContent == P.Placeholder {
        
        self.loader = loader
        self.key = .all
        self.keyPath = objectKeyPath
        self.contentBuilder = contentBuilder
        self.placeholderContentBuilder = {
            placeholderView.placeholder
        }
    }
}

// No Key, Activity Indicator
extension Load where Loader.Key == SimpleKey, PlaceholderContent == ProgressView<EmptyView, EmptyView> {
    init(with loader: Loader,
         objectKeyPath: KeyPath<Loader.Object, Value?>,
         @ViewBuilder content contentBuilder: @escaping (Value) -> Content) {
        
        self.loader = loader
        self.key = .all
        self.keyPath = objectKeyPath
        self.contentBuilder = contentBuilder
        self.placeholderContentBuilder = {
            ProgressView()
        }
    }
}

// No Key, Base Object
extension Load where Loader.Key == SimpleKey, Loader.Object == Value {
    init(with loader: Loader,
         @ViewBuilder content contentBuilder: @escaping (Value) -> Content,
         @ViewBuilder placeholder placeholderContentBuilder: @escaping () -> PlaceholderContent) {
        
        self.loader = loader
        self.key = .all
        self.contentBuilder = contentBuilder
        self.placeholderContentBuilder = placeholderContentBuilder
    }
    
    //    init<P: HasPlaceholder>(with loader: Loader,
    //         placeholderView: P.Type,
    //         @ViewBuilder content contentBuilder: @escaping (Value) -> Content) {
    //
    //        self.loader = loader
    //        self.key = .all
    //        self.contentBuilder = contentBuilder
    //        self.placeholderContentBuilder = {
    //            placeholderView.placeholder
    //        }
    //    }
}

// No Key, Base Object, Activity Indicator
extension Load where Loader.Key == SimpleKey, Loader.Object == Value, PlaceholderContent == ProgressView<EmptyView, EmptyView> {
    init(with loader: Loader,
         content contentBuilder: @escaping (Value) -> Content) {
        
        self.loader = loader
        self.key = .all
        self.contentBuilder = contentBuilder
        self.placeholderContentBuilder = {
            ProgressView()
        }
    }
}

// Base Object
extension Load where Value == Loader.Object {
    init(with loader: Loader,
         key: Loader.Key,
         @ViewBuilder content contentBuilder: @escaping (Value) -> Content,
         @ViewBuilder placeholder placeholderContentBuilder: @escaping () -> PlaceholderContent) {
        
        self.loader = loader
        self.key = key
        self.contentBuilder = contentBuilder
        self.placeholderContentBuilder = placeholderContentBuilder
    }
    
    init<P: HasPlaceholder>(with loader: Loader,
                            key: Loader.Key,
                            placeholderView: P.Type,
                            @ViewBuilder content contentBuilder: @escaping (Value) -> Content) where PlaceholderContent == P.Placeholder {
        
        self.loader = loader
        self.key = key
        self.contentBuilder = contentBuilder
        self.placeholderContentBuilder = {
            placeholderView.placeholder
        }
    }
}

// Base Object, Activity Indicator
extension Load where Value == Loader.Object, PlaceholderContent == ProgressView<EmptyView, EmptyView> {
    init(with loader: Loader,
         key: Loader.Key,
         content contentBuilder: @escaping (Value) -> Content) {
        
        self.loader = loader
        self.key = key
        self.contentBuilder = contentBuilder
        self.placeholderContentBuilder = {
            ProgressView()
        }
    }
}

// Activity Indicator
extension Load where PlaceholderContent == ProgressView<EmptyView, EmptyView> {
    init(with loader: Loader,
         key: Loader.Key,
         objectKeyPath: KeyPath<Loader.Object, Value?>,
         @ViewBuilder content contentBuilder: @escaping (Value) -> Content) {
        
        self.loader = loader
        self.key = key
        self.keyPath = objectKeyPath
        self.contentBuilder = contentBuilder
        self.placeholderContentBuilder = {
            ProgressView()
        }
    }
}
