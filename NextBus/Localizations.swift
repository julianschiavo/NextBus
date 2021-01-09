//
//  String-Localizations.swift
//  NextBus
//
//  Created by Julian Schiavo on 20/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation

enum Localizations {
    
    static let nextBus =                NSLocalizedString("Next Bus", comment: "Next Bus app name")
    
    // MARK: - Home
    static let favoritesHeader =        NSLocalizedString("Favorites",
                                                          comment: "Header title for the list of routes favorited by the user")
    static let allRoutesHeader =        NSLocalizedString("All Routes",
                                                          comment: "Header title for the list of all routes (Apple Watch only)")
    static let searchHeader =           NSLocalizedString("Search",
                                                          comment: "Header title/button text for the search screen (Apple Watch only)")
    static let shownCompaniesHeader =   NSLocalizedString("Shown Companies:",
                                                          comment: "Header title for list of shown companies on the home screen")
    static let searchBarText =          NSLocalizedString("Search Routes",
                                                          comment: "Placeholder text for the route search bar")
    static let searchText =             NSLocalizedString("Search for a bus route by name or bus stop.",
                                                          comment: "Header title for list of shown companies on the home screen")
    static func searchResults(searchText: String) -> String {
        let format = NSLocalizedString("Results for \"%@\"",
                                       comment: "Title for the results after a user's search")
        return String.localizedStringWithFormat(format, searchText)
    }
    
    // MARK: - Stop List
    static let busStopsHeader =         NSLocalizedString("Bus Stops",
                                                          comment: "Header title for the list of bus stops")
    static let allBusStopsHeader =      NSLocalizedString("All Bus Stops",
                                                          comment: "Header title for the list of all bus stops")
    static let nearbyBusStopsHeader =   NSLocalizedString("Nearby Bus Stops",
                                                          comment: "Header title for the list of bus stops that are near the user")
    static let overnightLabel =         NSLocalizedString("Overnight",
                                                          comment: "Label shown for overnight routes")
    
    // MARK: - ETA List
    static func detailsLastUpdatedFooter(_ lastUpdatedText: String) -> String {
        let format = NSLocalizedString("Last updated %@",
                                       comment: "Footer text displaying the last time the data was updated (%@ is the localized date (X minutes ago))")
        return String.localizedStringWithFormat(format, lastUpdatedText)
    }
    static let detailsArrivingSoonHeader = NSLocalizedString("Arriving Soon",
                                                          comment: "Header title for the list of buses arriving soon")
    static let detailsAtPrefix = NSLocalizedString("At ", comment: "Prefix for the bus arrival time (e.g. At 11 PM)")
    static let detailsInPrefix = NSLocalizedString("In ", comment: "Prefix for the bus arrival time (e.g. In 5 minutes)")
    static let detailsMapHeader =       NSLocalizedString("Map",
                                                          comment: "Header title for the map showing where the bus stop is")
    static let detailsMapFooter =       NSLocalizedString("Tap for directions to the stop.",
                                                          comment: "Footer text to tell users to tap the map to see walking directions to the bus stop")
    
    // MARK: - Support
    static let supportContactTitle =    NSLocalizedString("Contact Support?",
                                                       comment: "Title for the pop up shown after tapping the support button")
    static let supportContactText =     NSLocalizedString("Contact support if you have a question or an issue with the app.",
                                                                comment: "Text for the pop up shown after tapping the support button")
    static let supportContactYesButton = NSLocalizedString("Contact",
                                                           comment: "Button text for the contact support button")
    static let supportDoNotEditText =   NSLocalizedString("Please do not edit anything below. Some non identifiable data has been added to assist me when helping you.",
                                                          comment: "Text shown in the email template when contacting support to avoid people editing information included in the email")
    static let supportIncludeScreenshotButton = NSLocalizedString("Include",
                                                                  comment: "Button text to include a screenshot with the support email")
    static let supportDoNotIncludeScreenshotButton = NSLocalizedString("Don't Include",
                                                                       comment: "Button text to NOT include a screenshot with the support email")
    static let supportIncludeScreenshotTitle = NSLocalizedString("Would you like to include a screenshot in your email?",
                                                                 comment: "Title for the pop up shown asking users if they want to include a screenshot with the support email")
    static let supportIncludeScreenshotText = NSLocalizedString("If you're reporting an issue, include a screenshot of the app to help the developer understand your problem.",
                                                                 comment: "Text for the pop up shown asking users if they want to include a screenshot with the support email")
    
    // MARK: - Loading
    static let loadingRoutesTitle =     NSLocalizedString("Loading Routes...",
                                                          comment: "Title shown while loading routes")
    static let loadingRoutesText =      NSLocalizedString("If routes aren't loading, make sure you are connected to the internet.",
                                                          comment: "Description and instructional text shown while loading routes to help user")
    static let loadingBusStopsTitle =   NSLocalizedString("Loading Bus Stops...",
                                                          comment: "Title shown while loading bus stops")
    static let loadingBusStopsText =    NSLocalizedString("If bus stops aren't loading, make sure you are connected to the internet.",
                                                          comment: "Description and instructional text shown while loading bus stops to help user")
    static let loadingArrivalInfoTitle = NSLocalizedString("Loading Arrival Information...",
                                                          comment: "Title shown while loading arrival information")
    static let loadingArrivalInfoText = NSLocalizedString("If arrival information isn't loading, make sure you are connected to the internet.",
                                                          comment: "Description and instructional text shown while loading arrival information to help user")
    
    // MARK: - Errors
    static let errorArrivalInformationNotAvailable = NSLocalizedString("Arrival information is not currently available. This route may be diverted, suspended, or not currently in service.",
                                                                       comment: "Error text shown when their is no arrival information available")
    static let errorNoFavoritesTitle =  NSLocalizedString("No Favorites",
                                                          comment: "Title for the error shown when the user hasn't favorited any routes (Apple Wtach only)")
    static let errorNoFavoritesText =   NSLocalizedString("Tap the heart to favorite your most used routes and access them easily.",
                                                          comment: "Instructional text for the error shown when the user hasn't favorited any routes (Apple Watch only)")
    static let errorNoBusStopsTitle =   NSLocalizedString("No Bus Stops Found",
                                                          comment: "Title for the error shown when no bus stops were found (Apple Watch only)")
    static let errorNoBusStopsText =    NSLocalizedString("This route may be diverted, suspended, or not currently in service.",
                                                          comment: "Text for the error shown when no bus stops were found (Apple Watch only)")
    static let errorEmptySearch =       NSLocalizedString("Empty Search",
                                                          comment: "Title for the error shown when the user's search is empty")
    static let errorNoResultsTitle =    NSLocalizedString("No Routes Found",
                                                          comment: "Title for the error shown when the user's search found no routes")
    static let errorNoResultsText =     NSLocalizedString("If search isn't working, make sure you are connected to the internet.",
                                                          comment: "Text for the error shown when the user's search found no routes")
    
    // MARK: - Reused
    static func routeTitle(routeName: String) -> String {
        let format = NSLocalizedString("Route %@", comment: "Title for a route")
        return String.localizedStringWithFormat(format, routeName)
    }
    static func routeTowards(routeName: String, destination: String) -> String {
        let format = NSLocalizedString("%@ Towards %@",
                                       comment: "Title shown for a route going towards a destination")
        return String.localizedStringWithFormat(format, routeName, destination)
    }
    static func routeOriginAndDestination(origin: String, destination: String) -> String {
        let format = NSLocalizedString("%@ to %@",
                                       comment: "Text displaying a route's origin and destination in a certain direction (%@ is a destination or origin)")
        return String.localizedStringWithFormat(format, origin, destination)
    }
    static let oneWay =                 NSLocalizedString("One Way",
                                                          comment: "Text shown for one way routes")
    static let inbound =                NSLocalizedString("Inbound",
                                                          comment: "Text shown for routes in the inbound direction (from destination to origin)")
    static let outbound =               NSLocalizedString("Outbound",
                                                          comment: "Text shown for routes in the outbound direction (from origin to destination)")
    static let favoriteButton =         NSLocalizedString("Favorite",
                                                          comment: "Button text for the favorite button (favorites a route)")
    static let unfavoriteButton =       NSLocalizedString("Unfavorite",
                                                          comment: "Button text for the unfavorite button (unfavorites a route)")
    
    // MARK: - Generic
    static let error =                  NSLocalizedString("An Error Occured",
                                                          comment: "Title shown in a pop up when an error has occured")
    static let ok =                     NSLocalizedString("OK",
                                                          comment: "OK button text (to dismiss a pop up)")
    static let cancel =                 NSLocalizedString("Cancel",
                                                          comment: "Cancel button text (to cancel an action)")
    static let retry =                  NSLocalizedString("Retry",
                                                          comment: "Retry button text (to retry a failed action)")
}
