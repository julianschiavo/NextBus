//
//  ModelID.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation

struct ModelID<Value>: Codable, CustomStringConvertible, Equatable, ExpressibleByStringLiteral, Hashable, Identifiable {
    let string: String
    
    static var placeholder: Self<Value> {
        "placeholder"
    }
    
    var isValid: Bool {
        !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isPlaceholder: Bool {
        self == Self<Value>.placeholder
    }
    
    // MARK: - Codable
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        string = try container.decode(String.self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        string
    }
    
    // MARK: - ExpressibleByStringLiteral
    
    init(stringLiteral value: String) {
        string = value
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(string)
    }
    
    // MARK: - Identifiable
    
    var id: String {
        string
    }
}

// MARK: - Custom Operators
extension ModelID {
    static func == (lhs: Self, rhs: String) -> Bool {
        lhs.string == rhs
    }
    
    static func + (lhs: Self, rhs: String) -> String {
        lhs.string + rhs
    }
}

// MARK: - Convenience Mapping for Collections
extension Collection where Element == String {
    func mapToIDs<T>() -> [ModelID<T>] {
        map(ModelID<T>.init)
    }
    
    func mapToIDs<T>(ofType type: ModelID<T>.Type) -> [ModelID<T>] {
        map(ModelID<T>.init)
    }
}
