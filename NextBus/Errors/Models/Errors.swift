//
//  Errors.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation

enum Errors {
    
    /// There was an issue connecting to the internet
//    static let noInternetConnection =
//        CustomAssistedError(title: "You’re not connected to the Internet.",
//                            recoverySuggestion: "Make sure you are connected to Wi-Fi or your cellular network, then try again.")
    
    /// The action requires the user to be signed in (authenticated)
//    static let unauthenticated =
//        CustomAssistedError(title: "Sign In Required",
//                            description: "You need to sign in to do that.",
//                            recoverySuggestion: "Sign in or create an account, then try again.")
    
    /// An unknown, or internal, error occurred
    static let unknown =
        CustomAssistedError(title: Localizable.genericErrorTitle,
                            description: Localizable.genericErrorDescription,
                            recoverySuggestion: genericRecoverySuggestion)
    
    static let genericRecoverySuggestion = Localizable.genericErrorSuggestion
}
