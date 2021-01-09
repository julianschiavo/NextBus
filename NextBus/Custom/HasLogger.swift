//
//  HasLogger.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import OSLog

extension Logger {
    /// The logger subsystem for this package
    private static let subsystem = (Bundle.main.bundleIdentifier ?? "")
    
    /// Creates a new logger for a category
    /// - Parameter category: The logger category
    /// - Returns: A `Logger` object
    static func `for`(_ category: String) -> Logger {
        Logger(subsystem: subsystem, category: "App." + category)
    }
}

/// A type that has a shared `OSLog` `Logger`
protocol HasLogger {
    /// A shared `Logger` object for log messages emitted within this class
    static var logger: Logger { get }
    /// The category to use for the Logger
    static var category: String { get }
    
    /// The logger to use for log messages emitted within this class
    var logger: Logger { get }
}

extension HasLogger {
    static var logger: Logger { Logger.for(category) }
    static var category: String { String(describing: self) }
    
    var logger: Logger { Self.logger }
}
