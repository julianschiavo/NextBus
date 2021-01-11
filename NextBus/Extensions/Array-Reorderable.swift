//
//  Array-Reorderable.swift
//  NextBus
//
//  Created by Julian Schiavo on 11/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Foundation

protocol Reorderable {
    associatedtype OrderKey: Equatable
    var orderKey: OrderKey { get }
}

extension Reorderable where Self: Identifiable {
    var orderKey: ID { id }
}

extension Array where Element: Reorderable {
    func reorder(using preferredOrder: [Element.OrderKey]) -> [Element] {
        sorted {
            guard let first = preferredOrder.firstIndex(of: $0.orderKey) else {
                return false
            }
            
            guard let second = preferredOrder.firstIndex(of: $1.orderKey) else {
                return true
            }
            
            return first < second
        }
    }
}
