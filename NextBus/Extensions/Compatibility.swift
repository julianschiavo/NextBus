//
//  Compatibility.swift
//  NextBus
//
//  Created by Julian Schiavo on 12/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import CoreLocation
import SwiftUI

// MARK: - Mac & Watch Only

#if !os(iOS)
/// The instance that describes the behavior and appearance of an inset grouped list.
typealias InsetGroupedListStyle = PlainListStyle

class RouteSearchToolbar {
    init(searchText: Binding<String>) { }
}

extension ToolbarItemPlacement {
    /// The item is placed in the trailing edge of the navigation bar.
    public static let navigationBarTrailing: ToolbarItemPlacement = .automatic
}

extension View {
    func navigationBarSearch(_ searchText: Binding<String>, toolbar: () -> Any? = { nil }) -> some View {
        self
    }
}
#endif

// MARK: - Mac Only

#if os(macOS)
extension CLAuthorizationStatus {
    // User has granted authorization to use their location only while
    // they are using your app.
    static let authorized = CLAuthorizationStatus.authorized
}

/// A date picker style that displays an interactive calendar or clock.
typealias GraphicalDatePickerStyle = DefaultDatePickerStyle

/// A view for presenting a stack of views representing a visible path in a
/// navigation hierarchy.
typealias iOSNavigationView = Group

/// A `TabViewStyle` that implements a paged scrolling `TabView`.
typealias PageTabViewStyle = DefaultTabViewStyle

extension NavigationViewStyle where Self == ColumnNavigationViewStyle {
    /// A navigation view style represented by a view stack that only shows a single top view at a time.
    static var stacks: ColumnNavigationViewStyle {
        .columns
    }
}

/// A configuration for a navigation bar that represents a view at the top of a navigation stack.
struct NavigationBarItem {
    /// A style for displaying the title of a navigation bar.
    enum TitleDisplayMode {
        /// Display the title within the standard bounds of the navigation bar.
        case inline
    }
}

/// The centralized point of control and coordination for apps running in iOS.
struct UIApplication {
    /// A string used to create a URL to open Settings.
    static let openSettingsURLString = "nextbus://"
}
#endif

// MARK: - iPhone Only

#if os(iOS)
extension CLAuthorizationStatus {
    // User has granted authorization to use their location only while
    // they are using your app.  Note: You can reflect the user's
    // continued engagement with your app using
    // -allowsBackgroundLocationUpdates.
    static let authorized = CLAuthorizationStatus.authorizedWhenInUse
}

/// A view for presenting a stack of views representing a visible path in a
/// navigation hierarchy.
typealias iOSNavigationView = NavigationView
#endif

#if !os(macOS)
extension NavigationViewStyle where Self == StackNavigationViewStyle {
    /// A navigation view style represented by a view stack that only shows a single top view at a time.
    static var stacks: StackNavigationViewStyle {
        .stack
    }
}
#endif

// MARK: - Watch Only

#if os(watchOS)
extension CLAuthorizationStatus {
    // User has granted authorization to use their location only while
    // they are using your app.  Note: You can reflect the user's
    // continued engagement with your app using
    // -allowsBackgroundLocationUpdates.
    static let authorized = CLAuthorizationStatus.authorizedWhenInUse
}

/// A view that shows or hides another content view, based on the state of a
/// disclosure control.
///
/// A disclosure group view consists of a label to identify the contents, and a
/// control to show and hide the contents. Showing the contents puts the
/// disclosure group into the "expanded" state, and hiding them makes the
/// disclosure group "collapsed".
struct DisclosureGroup<Label: View, Content: View>: View {
    
    private var content: Content
    private var label: Label
    
    /// Creates a disclosure group with the given label and content views.
    ///
    /// - Parameters:
    ///   - content: The content shown when the disclosure group expands.
    ///   - label: A view that describes the content of the disclosure group.
    init(@ViewBuilder content: @escaping () -> Content, @ViewBuilder label: () -> Label) {
        self.content = content()
        self.label = label()
    }
    
    /// The content and behavior of the view.
    var body: some View {
        content
    }
}

/// The behavior and appearance of a sidebar or source list.
typealias SidebarListStyle = CarouselListStyle
#endif

// MARK: - Specific Extensions

extension View {
    /// Positions this view within an invisible frame having the specified size
    /// constraints.
    @ViewBuilder func macMinFrame(width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        #if os(macOS)
        frame(minWidth: width, minHeight: height)
        #else
        self
        #endif
    }
    
    /// Positions this view within an invisible frame having the specified size
    /// constraints.
    @ViewBuilder func macFrame(width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        #if os(macOS)
        frame(width: width, height: height)
        #else
        self
        #endif
    }
    
    /// Positions this view within an invisible frame having the specified size
    /// constraints.
    @ViewBuilder func macMaxFrame(width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        #if os(macOS)
        frame(maxWidth: width, maxHeight: height)
        #else
        self
        #endif
    }
    
    /// Sets the style for buttons within this view to a button style with a
    /// custom appearance and custom interaction behavior.
    @ViewBuilder func macCustomButton() -> some View {
        #if os(macOS)
        buttonStyle(.plain)
        #else
        self
        #endif
    }
    
    /// A view that pads this view inside the specified edge insets with a
    /// system-calculated amount of padding.
    ///
    /// - Parameters:
    ///   - length: The amount to inset this view on the specified edges. If
    ///     `nil`, the amount is the system-default amount.
    ///
    /// - Returns: A view that pads this view using the specified edge insets
    ///   with specified amount of padding.
    @ViewBuilder func macPadding(_ length: CGFloat? = nil) -> some View {
        #if os(macOS)
        padding(length ?? 0)
        #else
        self
        #endif
    }
    
    /// A view that pads this view inside the specified edge insets with a
    /// system-calculated amount of padding.
    ///
    /// - Parameters:
    ///   - edges: The set of edges along which to pad this view; if `nil` the
    ///     specified or system-calculated mount is applied to all edges.
    ///   - length: The amount to inset this view on the specified edges. If
    ///     `nil`, the amount is the system-default amount.
    ///
    /// - Returns: A view that pads this view using the specified edge insets
    ///   with specified amount of padding.
    @ViewBuilder func macPadding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> some View {
        #if os(macOS)
        padding(edges, length)
        #else
        self
        #endif
    }
    
    @ViewBuilder func iOSBackground<Background: View>(_ background: Background, alignment: Alignment = .center) -> some View {
        #if os(iOS)
        self.background(background, alignment: alignment)
        #else
        self
        #endif
    }
    
    /// Positions this view within an invisible frame having the specified size
    /// constraints.
    @ViewBuilder func iOSMaxFrame(width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        #if os(iOS)
        frame(maxWidth: width, maxHeight: height)
        #else
        self
        #endif
    }
    
    /// A view that pads this view inside the specified edge insets with a
    /// system-calculated amount of padding.
    ///
    /// - Parameters:
    ///   - length: The amount to inset this view on the specified edges. If
    ///     `nil`, the amount is the system-default amount.
    ///
    /// - Returns: A view that pads this view using the specified edge insets
    ///   with specified amount of padding.
    @ViewBuilder func iOSPadding(_ length: CGFloat? = nil) -> some View {
        #if os(iOS)
        padding(length ?? 0)
        #else
        self
        #endif
    }
    
    /// A view that pads this view inside the specified edge insets with a
    /// system-calculated amount of padding.
    ///
    /// - Parameters:
    ///   - edges: The set of edges along which to pad this view; if `nil` the
    ///     specified or system-calculated mount is applied to all edges.
    ///   - length: The amount to inset this view on the specified edges. If
    ///     `nil`, the amount is the system-default amount.
    ///
    /// - Returns: A view that pads this view using the specified edge insets
    ///   with specified amount of padding.
    @ViewBuilder func iOSPadding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> some View {
        #if os(iOS)
        padding(edges, length)
        #else
        self
        #endif
    }
    
    /// A view that pads this view inside the specified edge insets with a
    /// system-calculated amount of padding.
    ///
    /// - Parameters:
    ///   - edges: The set of edges along which to pad this view; if `nil` the
    ///     specified or system-calculated mount is applied to all edges.
    ///   - length: The amount to inset this view on the specified edges. If
    ///     `nil`, the amount is the system-default amount.
    ///
    /// - Returns: A view that pads this view using the specified edge insets
    ///   with specified amount of padding.
    @ViewBuilder func watchPadding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> some View {
        #if os(watchOS)
        padding(edges, length)
        #else
        self
        #endif
    }
    
    /// Configures the title display mode for this view.
    ///
    /// - Parameter displayMode: The style to use for displaying the title.
    @ViewBuilder func navigationTitleDisplayMode(_ displayMode: NavigationBarItem.TitleDisplayMode) -> some View {
        #if os(iOS)
        navigationBarTitleDisplayMode(displayMode)
        #else
        self
        #endif
    }
}
