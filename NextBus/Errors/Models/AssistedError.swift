//
//  AssistedError.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation

protocol AssistedError: LocalizedError {
    /// A title briefly describing the error.
    var title: String { get }
    /// A message describing what error occurred.
    var description: String? { get }
    /// A message describing how one might recover from the failure.
    var recoverySuggestion: String? { get }
}

extension AssistedError {
    /// A message describing what error occurred.
    public var errorDescription: String? {
        description
    }
}
