//
//  Errors.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation

enum Errors {
    
    static let invalidFile =
        CustomAssistedError(title: "Invalid File",
                            description: "The file you selected is invalid.",
                            recoverySuggestion: "Try select another file.")
    
    /// There was an issue connecting to the internet
    static let noInternetConnection =
        CustomAssistedError(title: "You’re not connected to the Internet.",
                            recoverySuggestion: "Make sure you are connected to Wi-Fi or your cellular network, then try again.")
    
    /// The action requires the user to be signed in (authenticated)
    static let unauthenticated =
        CustomAssistedError(title: "Sign In Required",
                            description: "You need to sign in to do that.",
                            recoverySuggestion: "Sign in or create an account, then try again.")
    
    /// An unknown, or internal, error occurred
    static let unknown =
        CustomAssistedError(title: "An error occurred",
                            description: "We're not sure what happened.",
                            recoverySuggestion: genericRecoverySuggestion)
    
    static let genericRecoverySuggestion = "Try again later or contact support."
}

//@available(swift, obsoleted: 1.0, renamed: "Errors")
//enum DefaultError {
//    static let noInternetConnection = CustomError(title: "You’re not connected to the Internet.",
//                                                  message: "Make sure you are connected to Wi-Fi or your cellular network, then try again.")
//    static let unknown = CustomError(title: "An error occurred",
//                                     message: "Please try again later or contact support if this continues.")
//}

typealias DefaultError = Errors
