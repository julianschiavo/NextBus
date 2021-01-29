//
//  HasLogger.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

#if !os(watchOS)
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
#endif

/// A type that has a shared `OSLog` `Logger`
protocol HasLogger {
    #if !os(watchOS)
    /// A shared `Logger` object for log messages emitted within this class
    static var logger: Logger { get }
    #endif
    
    /// The category to use for the Logger
    static var category: String { get }
    
    #if !os(watchOS)
    /// The logger to use for log messages emitted within this class
    var logger: Logger { get }
    #endif
}

extension HasLogger {
    #if !os(watchOS)
    static var logger: Logger { Logger.for(category) }
    #endif
    static var category: String { String(describing: self) }
    
    #if !os(watchOS)
    var logger: Logger { Self.logger }
    #endif
}
