// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum InfoPlist {
    /// Next Bus
    internal static let cfBundleDisplayName = L10n.tr("InfoPlist", "CFBundleDisplayName")
    /// Next Bus
    internal static let cfBundleName = L10n.tr("InfoPlist", "CFBundleName")
    /// See nearby bus stops and get directions to the closest stop.
    internal static let nsLocationUsageDescription = L10n.tr("InfoPlist", "NSLocationUsageDescription")
    /// See nearby bus stops and get directions to the closest stop.
    internal static let nsLocationWhenInUseUsageDescription = L10n.tr("InfoPlist", "NSLocationWhenInUseUsageDescription")
  }
  internal enum Localizable {
    /// Add to Favorites
    internal static let addToFavorites = L10n.tr("Localizable", "ADD_TO_FAVORITES")
    /// Add to Siri
    internal static let addToSiri = L10n.tr("Localizable", "ADD_TO_SIRI")
    /// Next Bus
    internal static let appName = L10n.tr("Localizable", "APP_NAME")
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "CANCEL")
    /// Change
    internal static let change = L10n.tr("Localizable", "CHANGE")
    /// Choose
    internal static let choose = L10n.tr("Localizable", "CHOOSE")
    /// Create
    internal static let create = L10n.tr("Localizable", "CREATE")
    /// Delete
    internal static let delete = L10n.tr("Localizable", "DELETE")
    /// Directions
    internal static let directionsButton = L10n.tr("Localizable", "DIRECTIONS_BUTTON")
    /// Done
    internal static let done = L10n.tr("Localizable", "DONE")
    /// Ends
    internal static let ends = L10n.tr("Localizable", "ENDS")
    /// from %@
    internal static func from(_ p1: Any) -> String {
      return L10n.tr("Localizable", "FROM %@", String(describing: p1))
    }
    /// From
    internal static let fromPlaceholder = L10n.tr("Localizable", "FROM_PLACEHOLDER")
    /// We're not sure what happened.
    internal static let genericErrorDescription = L10n.tr("Localizable", "GENERIC_ERROR_DESCRIPTION")
    /// Try again later or contact support.
    internal static let genericErrorSuggestion = L10n.tr("Localizable", "GENERIC_ERROR_SUGGESTION")
    /// An error occurred
    internal static let genericErrorTitle = L10n.tr("Localizable", "GENERIC_ERROR_TITLE")
    /// Inbound
    internal static let inbound = L10n.tr("Localizable", "INBOUND")
    /// Loading Route...
    internal static let loadingRoute = L10n.tr("Localizable", "LOADING_ROUTE")
    /// Loading Routes...
    internal static let loadingRoutes = L10n.tr("Localizable", "LOADING_ROUTES")
    /// Loading Stop...
    internal static let loadingStop = L10n.tr("Localizable", "LOADING_STOP")
    /// Loading Stops...
    internal static let loadingStops = L10n.tr("Localizable", "LOADING_STOPS")
    /// Name
    internal static let name = L10n.tr("Localizable", "NAME")
    /// OK
    internal static let ok = L10n.tr("Localizable", "OK")
    /// One Way
    internal static let oneWay = L10n.tr("Localizable", "ONE_WAY")
    /// Outbound
    internal static let outbound = L10n.tr("Localizable", "OUTBOUND")
    /// Remove Favorite
    internal static let removeFavorite = L10n.tr("Localizable", "REMOVE_FAVORITE")
    /// Remove from Recents
    internal static let removeRecent = L10n.tr("Localizable", "REMOVE_RECENT")
    /// Route
    internal static let route = L10n.tr("Localizable", "ROUTE")
    /// Route %@
    internal static func routeName(_ p1: Any) -> String {
      return L10n.tr("Localizable", "ROUTE_NAME %@", String(describing: p1))
    }
    /// Save
    internal static let save = L10n.tr("Localizable", "SAVE")
    /// Search
    internal static let search = L10n.tr("Localizable", "SEARCH")
    /// Select Route
    internal static let selectRoute = L10n.tr("Localizable", "SELECT_ROUTE")
    /// Select Stop
    internal static let selectStop = L10n.tr("Localizable", "SELECT_STOP")
    /// Settings
    internal static let settings = L10n.tr("Localizable", "SETTINGS")
    /// Share
    internal static let share = L10n.tr("Localizable", "SHARE")
    /// Starts
    internal static let starts = L10n.tr("Localizable", "STARTS")
    /// Stop
    internal static let stop = L10n.tr("Localizable", "STOP")
    /// Time
    internal static let time = L10n.tr("Localizable", "TIME")
    /// to %@
    internal static func to(_ p1: Any) -> String {
      return L10n.tr("Localizable", "TO %@", String(describing: p1))
    }
    /// To
    internal static let toPlaceholder = L10n.tr("Localizable", "TO_PLACEHOLDER")
    internal enum BusDetail {
      /// Show Nearby Bus Stops
      internal static let showNearbyBusStops = L10n.tr("Localizable", "BUS_DETAIL.SHOW_NEARBY_BUS_STOPS")
    }
    internal enum Category {
      /// Bus
      internal static let bus = L10n.tr("Localizable", "CATEGORY.BUS")
      /// Ferry
      internal static let ferry = L10n.tr("Localizable", "CATEGORY.FERRY")
      /// Minibus
      internal static let minibus = L10n.tr("Localizable", "CATEGORY.MINIBUS")
      /// Train
      internal static let train = L10n.tr("Localizable", "CATEGORY.TRAIN")
      /// Tram
      internal static let tram = L10n.tr("Localizable", "CATEGORY.TRAM")
    }
    internal enum Clip {
      /// Continue to All Routes
      internal static let continueToRoutes = L10n.tr("Localizable", "CLIP.CONTINUE_TO_ROUTES")
      /// Failed to load route.
      internal static let failedToLoadRoute = L10n.tr("Localizable", "CLIP.FAILED_TO_LOAD_ROUTE")
    }
    internal enum Company {
      /// Citybus
      internal static let ctb = L10n.tr("Localizable", "COMPANY.CTB")
      /// Discovery Bay Bus
      internal static let db = L10n.tr("Localizable", "COMPANY.DB")
      /// Ferry
      internal static let ferry = L10n.tr("Localizable", "COMPANY.FERRY")
      /// Green Minibus
      internal static let gmb = L10n.tr("Localizable", "COMPANY.GMB")
      /// KMB
      internal static let kmb = L10n.tr("Localizable", "COMPANY.KMB")
      /// KMB & Citybus
      internal static let kmbCtb = L10n.tr("Localizable", "COMPANY.KMB_CTB")
      /// KMB & NWFB
      internal static let kmbNwfb = L10n.tr("Localizable", "COMPANY.KMB_NWFB")
      /// MTR Feeder
      internal static let lrtFeeder = L10n.tr("Localizable", "COMPANY.LRT_FEEDER")
      /// Long Win Bus
      internal static let lwb = L10n.tr("Localizable", "COMPANY.LWB")
      /// Long Win Bus & Citybus
      internal static let lwbCtb = L10n.tr("Localizable", "COMPANY.LWB_CTB")
      /// MTR
      internal static let mtr = L10n.tr("Localizable", "COMPANY.MTR")
      /// New Lantao Bus
      internal static let nlb = L10n.tr("Localizable", "COMPANY.NLB")
      /// NWFB
      internal static let nwfb = L10n.tr("Localizable", "COMPANY.NWFB")
      /// Ma Wan Bus
      internal static let pi = L10n.tr("Localizable", "COMPANY.PI")
      /// Tram
      internal static let tram = L10n.tr("Localizable", "COMPANY.TRAM")
      /// Unknown
      internal static let unknown = L10n.tr("Localizable", "COMPANY.UNKNOWN")
      /// LMC Coach
      internal static let xb = L10n.tr("Localizable", "COMPANY.XB")
    }
    internal enum Dashboard {
      /// All Favorites
      internal static let allFavorites = L10n.tr("Localizable", "DASHBOARD.ALL_FAVORITES")
      /// Currently: %@
      internal static func currentSchedule(_ p1: Any) -> String {
        return L10n.tr("Localizable", "DASHBOARD.CURRENT_SCHEDULE %@", String(describing: p1))
      }
      /// Favorites
      internal static let favorites = L10n.tr("Localizable", "DASHBOARD.FAVORITES")
      /// Dashboard
      internal static let name = L10n.tr("Localizable", "DASHBOARD.NAME")
      /// No Favorites
      internal static let noFavorites = L10n.tr("Localizable", "DASHBOARD.NO_FAVORITES")
      /// No Recents
      internal static let noRecents = L10n.tr("Localizable", "DASHBOARD.NO_RECENTS")
      /// Recents
      internal static let recents = L10n.tr("Localizable", "DASHBOARD.RECENTS")
    }
    internal enum Directions {
      /// %@ mins
      internal static func mins(_ p1: Any) -> String {
        return L10n.tr("Localizable", "DIRECTIONS.%@ MINS", String(describing: p1))
      }
      /// Change Routing
      internal static let changeRouting = L10n.tr("Localizable", "DIRECTIONS.CHANGE_ROUTING")
      /// Current Location
      internal static let currentLocation = L10n.tr("Localizable", "DIRECTIONS.CURRENT_LOCATION")
      /// Enable
      internal static let enable = L10n.tr("Localizable", "DIRECTIONS.ENABLE")
      /// Finding Directions...
      internal static let findingDirections = L10n.tr("Localizable", "DIRECTIONS.FINDING_DIRECTIONS")
      /// Go
      internal static let go = L10n.tr("Localizable", "DIRECTIONS.GO")
      /// Get public transport directions around Hong Kong—wherever you are.
      internal static let locationRequiredDescription = L10n.tr("Localizable", "DIRECTIONS.LOCATION_REQUIRED_DESCRIPTION")
      /// Location access has been disabled. Enable it in the Settings app.
      internal static let locationRequiredError = L10n.tr("Localizable", "DIRECTIONS.LOCATION_REQUIRED_ERROR")
      /// Enable Location for Directions
      internal static let locationRequiredTitle = L10n.tr("Localizable", "DIRECTIONS.LOCATION_REQUIRED_TITLE")
      /// Directions
      internal static let name = L10n.tr("Localizable", "DIRECTIONS.NAME")
      /// Open Walking Directions
      internal static let openWalkingDirections = L10n.tr("Localizable", "DIRECTIONS.OPEN_WALKING_DIRECTIONS")
      /// Ride on the %@
      internal static func rideOnTrain(_ p1: Any) -> String {
        return L10n.tr("Localizable", "DIRECTIONS.RIDE_ON_TRAIN %@", String(describing: p1))
      }
      /// Search for a place or address
      internal static let searchForLocation = L10n.tr("Localizable", "DIRECTIONS.SEARCH_FOR_LOCATION")
      /// Searching...
      internal static let searching = L10n.tr("Localizable", "DIRECTIONS.SEARCHING")
      /// Select Routing
      internal static let selectRouting = L10n.tr("Localizable", "DIRECTIONS.SELECT_ROUTING")
      /// Take the %@
      internal static func takeTheBus(_ p1: Any) -> String {
        return L10n.tr("Localizable", "DIRECTIONS.TAKE_THE_BUS %@", String(describing: p1))
      }
      /// Take the Ferry
      internal static let takeTheFerry = L10n.tr("Localizable", "DIRECTIONS.TAKE_THE_FERRY")
      /// Take the Tram
      internal static let takeTheTram = L10n.tr("Localizable", "DIRECTIONS.TAKE_THE_TRAM")
      /// Walk to %@
      internal static func walkTo(_ p1: Any) -> String {
        return L10n.tr("Localizable", "DIRECTIONS.WALK_TO %@", String(describing: p1))
      }
      /// Which route?
      internal static let whichRoute = L10n.tr("Localizable", "DIRECTIONS.WHICH_ROUTE")
    }
    internal enum Notifications {
      /// Press and hold to check when the %@ will arrive.
      internal static func description(_ p1: Any) -> String {
        return L10n.tr("Localizable", "NOTIFICATIONS.DESCRIPTION %@", String(describing: p1))
      }
      /// It's time for %@.
      internal static func title(_ p1: Any) -> String {
        return L10n.tr("Localizable", "NOTIFICATIONS.TITLE %@", String(describing: p1))
      }
    }
    internal enum Routes {
      /// Routes
      internal static let name = L10n.tr("Localizable", "ROUTES.NAME")
    }
    internal enum Schedule {
      /// Add Schedule
      internal static let add = L10n.tr("Localizable", "SCHEDULE.ADD")
      /// Arrival Time Notifications
      internal static let arrivalTimeNotifications = L10n.tr("Localizable", "SCHEDULE.ARRIVAL_TIME_NOTIFICATIONS")
      /// Delete Schedule
      internal static let delete = L10n.tr("Localizable", "SCHEDULE.DELETE")
      /// Create Schedules to quickly see your daily routes on Dashboard and receive notifications with bus arrival times.
      internal static let description = L10n.tr("Localizable", "SCHEDULE.DESCRIPTION")
      /// Edit Schedule
      internal static let edit = L10n.tr("Localizable", "SCHEDULE.EDIT")
      /// Receive notifications with the latest bus arrival time when schedules start.
      internal static let enableNotificationsDescription = L10n.tr("Localizable", "SCHEDULE.ENABLE_NOTIFICATIONS_DESCRIPTION")
      /// Enable Notifications
      internal static let enableNotificationsTitle = L10n.tr("Localizable", "SCHEDULE.ENABLE_NOTIFICATIONS_TITLE")
      /// Schedule
      internal static let name = L10n.tr("Localizable", "SCHEDULE.NAME")
      /// New Schedule
      internal static let new = L10n.tr("Localizable", "SCHEDULE.NEW")
      /// You will not receive notifications when schedules start.
      internal static let notificationsDisabledDescription = L10n.tr("Localizable", "SCHEDULE.NOTIFICATIONS_DISABLED_DESCRIPTION")
      /// Notifications Disabled
      internal static let notificationsDisabledTitle = L10n.tr("Localizable", "SCHEDULE.NOTIFICATIONS_DISABLED_TITLE")
    }
    internal enum Siri {
      internal enum GetUpcomingBuses {
        /// When's the next bus?
        internal static let phrase = L10n.tr("Localizable", "SIRI.GET_UPCOMING_BUSES.PHRASE")
        internal enum Phrase {
          /// When's the next %@?
          internal static func withRoute(_ p1: Any) -> String {
            return L10n.tr("Localizable", "SIRI.GET_UPCOMING_BUSES.PHRASE.WITH_ROUTE %@", String(describing: p1))
          }
          /// When's the next %@ from %@?
          internal static func withRouteStop(_ p1: Any, _ p2: Any) -> String {
            return L10n.tr("Localizable", "SIRI.GET_UPCOMING_BUSES.PHRASE.WITH_ROUTE %@ STOP %@", String(describing: p1), String(describing: p2))
          }
        }
      }
    }
    internal enum StopDetail {
      /// All Bus Stops
      internal static let allBusStops = L10n.tr("Localizable", "STOP_DETAIL.ALL_BUS_STOPS")
      /// Arrival information is not yet available for this route.
      internal static let arrivalInformationNotAvailable = L10n.tr("Localizable", "STOP_DETAIL.ARRIVAL_INFORMATION_NOT_AVAILABLE")
      /// Arrival information is not currently available. This route may be diverted, suspended, or not currently in service.
      internal static let arrivalInformationNotCurrentlyAvailable = L10n.tr("Localizable", "STOP_DETAIL.ARRIVAL_INFORMATION_NOT_CURRENTLY_AVAILABLE")
      /// Arriving Soon
      internal static let arrivingSoon = L10n.tr("Localizable", "STOP_DETAIL.ARRIVING_SOON")
      /// At 
      internal static let at = L10n.tr("Localizable", "STOP_DETAIL.AT")
      /// Info
      internal static let info = L10n.tr("Localizable", "STOP_DETAIL.INFO")
      /// Last updated %@
      internal static func lastUpdated(_ p1: Any) -> String {
        return L10n.tr("Localizable", "STOP_DETAIL.LAST_UPDATED", String(describing: p1))
      }
      /// Map
      internal static let map = L10n.tr("Localizable", "STOP_DETAIL.MAP")
      /// Nearby Bus Stops
      internal static let nearbyBusStops = L10n.tr("Localizable", "STOP_DETAIL.NEARBY_BUS_STOPS")
    }
    internal enum Upgrade {
      /// Next Bus+
      internal static let productName = L10n.tr("Localizable", "UPGRADE.PRODUCT_NAME")
      /// Upgrade now to get access!
      internal static let requiredDescription = L10n.tr("Localizable", "UPGRADE.REQUIRED_DESCRIPTION")
      /// Next Bus+ Required
      internal static let requiredTitle = L10n.tr("Localizable", "UPGRADE.REQUIRED_TITLE")
      /// Restore Purchases
      internal static let restorePurchases = L10n.tr("Localizable", "UPGRADE.RESTORE_PURCHASES")
      /// Create widgets, receive arrival notifications, and more!
      internal static let suggestedDescription = L10n.tr("Localizable", "UPGRADE.SUGGESTED_DESCRIPTION")
      /// Upgrade to Next Bus+
      internal static let suggestedTitle = L10n.tr("Localizable", "UPGRADE.SUGGESTED_TITLE")
      /// Upgrade to
      internal static let titlePrefix = L10n.tr("Localizable", "UPGRADE.TITLE_PREFIX")
      internal enum Notifications {
        /// Receive notifications when it's time for your daily routes
        internal static let description = L10n.tr("Localizable", "UPGRADE.NOTIFICATIONS.DESCRIPTION")
        /// Notifications
        internal static let title = L10n.tr("Localizable", "UPGRADE.NOTIFICATIONS.TITLE")
      }
      internal enum Schedule {
        /// Create schedules to see your daily routes on Dashboard
        internal static let description = L10n.tr("Localizable", "UPGRADE.SCHEDULE.DESCRIPTION")
        /// Schedule
        internal static let title = L10n.tr("Localizable", "UPGRADE.SCHEDULE.TITLE")
      }
      internal enum Support {
        /// Support future updates to the app by the independent developer
        internal static let description = L10n.tr("Localizable", "UPGRADE.SUPPORT.DESCRIPTION")
        /// Support Next Bus
        internal static let title = L10n.tr("Localizable", "UPGRADE.SUPPORT.TITLE")
      }
      internal enum Widgets {
        /// Add widgets to your home screen to instantly see arrival times
        internal static let description = L10n.tr("Localizable", "UPGRADE.WIDGETS.DESCRIPTION")
        /// Widgets
        internal static let title = L10n.tr("Localizable", "UPGRADE.WIDGETS.TITLE")
      }
    }
    internal enum Widgets {
      internal enum ArrivalTime {
        /// Failed to Load
        internal static let failedToLoad = L10n.tr("Localizable", "WIDGETS.ARRIVAL_TIME.FAILED_TO_LOAD")
        /// Live Arrival Time
        internal static let name = L10n.tr("Localizable", "WIDGETS.ARRIVAL_TIME.NAME")
        /// No Routes Selected
        internal static let noRoutesSelected = L10n.tr("Localizable", "WIDGETS.ARRIVAL_TIME.NO_ROUTES_SELECTED")
        /// Select a route to see bus arrival times.
        internal static let noRoutesSelectedDescription = L10n.tr("Localizable", "WIDGETS.ARRIVAL_TIME.NO_ROUTES_SELECTED_DESCRIPTION")
        /// No arrival time
        internal static let notAvailable = L10n.tr("Localizable", "WIDGETS.ARRIVAL_TIME.NOT_AVAILABLE")
        /// Widgets require Next Bus+
        internal static let upgradeRequired = L10n.tr("Localizable", "WIDGETS.ARRIVAL_TIME.UPGRADE_REQUIRED")
        /// Upgrade in the app to get live widgets!
        internal static let upgradeRequiredDescription = L10n.tr("Localizable", "WIDGETS.ARRIVAL_TIME.UPGRADE_REQUIRED_DESCRIPTION")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
