////
////  GetUpcomingBusesIntentHandler.swift
////  NextBus
////
////  Created by Julian Schiavo on 28/9/2019.
////  Copyright © 2019 Julian Schiavo. All rights reserved.
////
//
//import Intents
//import UIKit
//
//public class GetUpcomingBusesIntentHandler: NSObject, GetUpcomingBusesIntentHandling {
//    
//    enum IntentError: Error {
//        case failedToGetRoutes
//        case invalidRoute
//        
//        var localizedDescription: String {
//            switch self {
//            case .failedToGetRoutes: return "Failed to get bus routes. Open the Next Bus app, then try again."
//            case .invalidRoute: return "Invalid bus route."
//            }
//        }
//    }
//    
//    func route(for routeName: String) -> Route? {
//        return nil
////        for companyID in CompanyID.allCases {
////            guard let companyRoutes = APIManager.shared.routes(for: companyID)?.contents else { continue }
////            routes.append(contentsOf: companyRoutes)
////        }
//    }
//    
//    func bool(from nsNumber: NSNumber) -> Bool {
//        Bool(exactly: nsNumber) ?? false
//    }
//    
//    func isRouteOneWay(intent: GetUpcomingBusesIntent) -> Bool {
//        guard let nsNumber = intent.route?.isOneWay else { return false }
//        return bool(from: nsNumber)
//    }
//    
//    public func handle(intent: GetUpcomingBusesIntent, completion: @escaping (GetUpcomingBusesIntentResponse) -> Void) {
//        guard let inRoute = intent.route,
//            let route = Route.from(intentObject: inRoute),
//            let inStop = intent.stop,
//            let stop = Stop.from(intentObject: inStop),
//            intent.direction != .unknown else {
//            completion(GetUpcomingBusesIntentResponse(code: .failure, userActivity: nil))
//            return
//        }
//        let direction = Direction.from(intentObject: intent.direction)
//        
//        guard let stops = APIManager.shared.stops(for: route, in: direction),
//            stops.contains(where: { $0.id == stop.id && $0.name == stop.name }) else { return }
//        
//        
//        APIManager.shared.fetchETA(for: route, in: direction, stop: stop, priority: .normal) { result in
//            switch result {
//            case let .success(etas):
//                let inETAs = etas.map { $0.intentObject }
//                completion(.success(etas: inETAs))
//            case .failure:
//                completion(GetUpcomingBusesIntentResponse(code: .failure, userActivity: nil))
//            }
//        }
//    }
//    
//    public func resolveStop(for intent: GetUpcomingBusesIntent, with completion: @escaping (INStopResolutionResult) -> Void) {
//        guard let stop = intent.stop else {
//            completion(.needsValue())
//            return
//        }
//        completion(.success(with: stop))
//    }
//    
//    public func provideStopOptions(for intent: GetUpcomingBusesIntent, with completion: @escaping ([INStop]?, Error?) -> Void) {
//        guard let route = intent.route, intent.direction != .unknown else {
//            completion(nil, IntentError.invalidRoute)
//            return
//        }
//        
//        let direction = Direction.from(intentObject: intent.direction)
//        let stops = APIManager.shared.stops(for: route, in: direction)
//        let inStops = stops?.contents.map { $0.intentObject }
//        
//        completion(inStops, nil)
//    }
//    
//    public func resolveDirection(for intent: GetUpcomingBusesIntent, with completion: @escaping (GetUpcomingBusesDirectionResolutionResult) -> Void) {
//        guard intent.direction != .unknown else {
//            completion(.needsValue())
//            return
//        }
//        
//        let isOneWay = isRouteOneWay(intent: intent)
//        if isOneWay, intent.direction != .oneWay {
//            completion(.success(with: .oneWay))
//        } else if !isOneWay, intent.direction == .oneWay {
//            completion(.unsupported(forReason: .routeIsNotOneWay))
//        } else {
//            completion(.success(with: intent.direction))
//        }
//    }
//    
//    public func resolveRoute(for intent: GetUpcomingBusesIntent, with completion: @escaping (GetUpcomingBusesRouteResolutionResult) -> Void) {
//        guard let route = intent.route else {
//            completion(.needsValue())
//            return
//        }
//        
//        DispatchQueue.global(qos: .userInteractive).async {
//            var routes = [Route]()
//
//            return
//            for companyID in CompanyID.allCases {
//                guard let companyRoutes = APIManager.shared.routes(for: companyID)?.contents else { continue }
//                routes.append(contentsOf: companyRoutes)
//            }
//        }
//        
//        completion(.success(with: route))
//    }
//    
////    public func provideRouteOptions(for intent: GetUpcomingBusesIntent, with completion: @escaping ([INRoute]?, Error?) -> Void) {
////        DispatchQueue.global(qos: .userInteractive).async {
////            var routes = [Route]()
////
////            for companyID in CompanyID.allCases {
////                guard let companyRoutes = APIManager.shared.routes(for: companyID)?.contents else { continue }
////                routes.append(contentsOf: companyRoutes)
////            }
////
////            if routes.isEmpty {
////                completion(nil, IntentError.failedToGetRoutes)
////            } else {
////                let inRoutes = routes.map { $0.intentObject }
////                completion(inRoutes, nil)
////            }
////        }
////    }
//}
