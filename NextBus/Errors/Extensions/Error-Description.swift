//
//  Error-UserVisible.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation

extension Error {
    private var assistedError: AssistedError? {
        self as? AssistedError
    }
    
    var userVisibleTitle: String {
        assistedError?.title ?? nsError.localizedFailureReason ?? Errors.unknown.title
    }
    
    var userVisibleDescription: String? {
        assistedError?.description ?? nsErrorDescription ?? Errors.unknown.description
    }
    
    private var nsErrorDescription: String? {
        guard !nsError.localizedDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
        return nsError.localizedDescription
    }
    
    var userVisibleRecoverySuggestion: String? {
        assistedError?.recoverySuggestion ?? nsErrorRecoverySuggestion ?? Errors.unknown.recoverySuggestion
    }
    
    private var nsErrorRecoverySuggestion: String? {
        guard let suggestion = nsError.localizedRecoverySuggestion,
              !suggestion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
        return nsError.localizedRecoverySuggestion
    }
    
    var userVisibleOverallDescription: String {
        [userVisibleDescription, userVisibleRecoverySuggestion].compactMap { $0 }.joined(separator: " ")
    }
}
