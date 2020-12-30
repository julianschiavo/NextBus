//
//  NWFBCTB-API.swift
//  NextBus
//
//  Created by Julian Schiavo on 20/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

struct NWFBCTBAPI: API {
    
    typealias APIError = APIManager.APIError
    
    let baseURL: URL
    let companyIDs = CompanyID.nwfbctbIDs
    let backgroundQueue = DispatchQueue.global(qos: .userInteractive)
    
    init() {
        guard let baseURL = URL(string: "https://rt.data.gov.hk") else {
            fatalError("Mistyped URL")
        }
        self.baseURL = baseURL
    }
    
    // MARK: - Companies
    
    func fetchCompany(id: CompanyID, completion: @escaping (Result<Company, Error>) -> Void) {
        let type = "FetchCompany"
        
        let url = baseURL.appendingPathComponent("/v1/transport/citybus-nwfb/company/\(id.rawValue)")
        APIManager.request(ofType: type, didChangeStatus: .fetchStarting(url))
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                APIManager.request(ofType: type, didChangeStatus: .fetchFailed(url, error))
                completion(.failure(error ?? APIError.failedToLoad))
                return
            }
            APIManager.request(ofType: type, didChangeStatus: .fetchSuccessful(url))
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let rawCompany = try decoder.decode(NWFBCTBRawCompany.self, from: data)
                completion(.success(rawCompany.company))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Routes
    
    func fetchRoutes(companyID: CompanyID, route: String? = nil, urlSession: URLSession, completion: @escaping (Result<OrderedSet<Route>, Error>) -> Void) {
        let type = "FetchRoutes"
        
        var url = baseURL.appendingPathComponent("/v1/transport/citybus-nwfb/route/\(companyID)")
        if let route = route {
            url = url.appendingPathComponent("/\(route)")
        }
        APIManager.request(ofType: type, didChangeStatus: .fetchStarting(url))
        
        let task = urlSession.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                APIManager.request(ofType: type, didChangeStatus: .fetchFailed(url, error))
                completion(.failure(error ?? APIError.failedToLoad))
                return
            }
            APIManager.request(ofType: type, didChangeStatus: .fetchSuccessful(url))
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let rawRoute = try decoder.decode(NWFBCTBRawRoute.self, from: data)
                let routes = rawRoute.routes
                APIManager.shared.cache(routes, for: companyID)
                
                APIManager.request(ofType: type, didChangeStatus: .decodeSuccessful)
                completion(.success(routes))
            } catch {
                APIManager.request(ofType: type, didChangeStatus: .decodeFailed(url, error))
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: - Stops
    
    func updateStops(for route: Route, includingCached includeCached: Bool, urlSession: URLSession, completion: @escaping (Error?) -> Void) {
        let type = "UpdateStops"
        
        var error: Error?
        let group = DispatchGroup()
        
        group.enter()
        group.notify(queue: backgroundQueue, execute: {
            if let error = error {
                APIManager.request(ofType: type, didChangeStatus: .decodeFailed(nil, error))
            } else {
                APIManager.request(ofType: type, didChangeStatus: .decodeSuccessful)
            }
            completion(error)
        })
        
        if includeCached || !APIManager.shared.hasCachedStops(for: route, in: .inbound) {
            group.enter()
            fetchStops(for: route, in: .inbound, urlSession: urlSession) { result in
                if case let .failure(newError) = result {
                    error = newError
                }
                group.leave()
            }
        }
        
        if includeCached || !APIManager.shared.hasCachedStops(for: route, in: .outbound) {
            group.enter()
            fetchStops(for: route, in: .outbound, urlSession: urlSession) { result in
                if case let .failure(newError) = result {
                    error = newError
                }
                group.leave()
            }
        }
        
        group.leave()
    }
    
    func fetchStops(for route: Route, in direction: Direction, urlSession: URLSession, completion: @escaping (Result<OrderedSet<Stop>, Error>) -> Void) {
        fetchStops(route: route, direction: direction, urlSession: urlSession) { result in
            if case let .success(stops) = result { // Used to check if !stops.isEmpty
                self.backgroundQueue.async {
                    APIManager.shared.cache(stops, for: route, in: direction)
                }
            }
            
            completion(result)
        }
    }
    
    private func fetchStops(route: Route, direction: Direction, urlSession: URLSession, completion: @escaping (Result<OrderedSet<Stop>, Error>) -> Void) {
        fetchUnknownStops(route: route, direction: direction, urlSession: urlSession) { result in
            switch result {
            case let .success(unknownStops):
                self.fetchStops(unknownStops: unknownStops, urlSession: urlSession, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchStops(unknownStops: OrderedSet<NWFBCTBUnknownStop>, urlSession: URLSession, completion: @escaping (Result<OrderedSet<Stop>, Error>) -> Void) {
        var stops = [Stop]()
        var error: Error?
        
        let group = DispatchGroup()
        for unknownStop in unknownStops {
            group.enter()
            fetchStop(unknownStop: unknownStop, urlSession: urlSession) { result in
                switch result {
                case let .success(stop):
                    if var stop = stop {
                        stop.index = Int(unknownStop.index)
                        stops.append(stop)
                    }
                case let .failure(newError):
                    error = newError
                }
                group.leave()
            }
        }
        
        group.notify(queue: backgroundQueue) {
            if let error = error {
                completion(.failure(error))
            } else {
                let sortedStops = stops.sorted { first, second in
                    guard let firstIndex = first.index, let secondIndex = second.index else { return true }
                    return firstIndex < secondIndex
                }
                completion(.success(OrderedSet(sortedStops)))
            }
        }
    }
    
    private func fetchStop(unknownStop: NWFBCTBUnknownStop, urlSession: URLSession, completion: @escaping (Result<Stop?, Error>) -> Void) {
        let type = "FetchStop"
        
        let url = baseURL.appendingPathComponent("/v1/transport/citybus-nwfb/stop/\(unknownStop.id)")
        APIManager.request(ofType: type, didChangeStatus: .fetchStarting(url))
        
        let task = urlSession.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                APIManager.request(ofType: type, didChangeStatus: .fetchFailed(url, error))
                completion(.failure(error ?? APIError.failedToLoad))
                return
            }
            APIManager.request(ofType: type, didChangeStatus: .fetchSuccessful(url))
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let rawStop = try decoder.decode(NWFBCTBRawStop.self, from: data)
                
                APIManager.request(ofType: type, didChangeStatus: .decodeSuccessful)
                completion(.success(rawStop.stop))
            } catch {
                APIManager.request(ofType: type, didChangeStatus: .decodeFailed(url, error))
                
                switch error {
                case DecodingError.keyNotFound:
                    completion(.success(nil))
                default:
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    private func fetchUnknownStops(route: Route, direction: Direction, urlSession: URLSession, completion: @escaping (Result<OrderedSet<NWFBCTBUnknownStop>, Error>) -> Void) {
        let type = "FetchUnknownStops"
        
        let direction = NWFBCTBDirection.from(direction)
        let url = baseURL.appendingPathComponent("/v1/transport/citybus-nwfb/route-stop/\(route.companyID)/\(route.name)/\(direction.parameter)")
        APIManager.request(ofType: type, didChangeStatus: .fetchStarting(url))
        
        let task = urlSession.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                APIManager.request(ofType: type, didChangeStatus: .fetchFailed(url, error))
                completion(.failure(error ?? APIError.failedToLoad))
                return
            }
            APIManager.request(ofType: type, didChangeStatus: .fetchSuccessful(url))
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let rawUnknownStop = try decoder.decode(NWFBCTBRawUnknownStop.self, from: data)
                
                APIManager.request(ofType: type, didChangeStatus: .decodeSuccessful)
                completion(.success(rawUnknownStop.unknownStops))
            } catch {
                APIManager.request(ofType: type, didChangeStatus: .decodeFailed(url, error))
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: - ETA
    
    func fetchETA(for route: Route, in direction: Direction, stop: Stop, urlSession: URLSession, completion: @escaping (Result<OrderedSet<ETA>, Error>) -> Void) {
        let type = "FetchETA"
        
        let url = baseURL.appendingPathComponent("/v1/transport/citybus-nwfb/eta/\(route.companyID)/\(stop.id)/\(route.name)")
        APIManager.request(ofType: type, didChangeStatus: .fetchStarting(url))
        
        let task = urlSession.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                APIManager.request(ofType: type, didChangeStatus: .fetchFailed(url, error))
                completion(.failure(error ?? APIError.failedToLoad))
                return
            }
            APIManager.request(ofType: type, didChangeStatus: .fetchSuccessful(url))
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let rawETA = try decoder.decode(NWFBCTBRawETA.self, from: data)
                let etas = rawETA.etas(for: direction)
                
                APIManager.request(ofType: type, didChangeStatus: .decodeSuccessful)
                completion(.success(etas))
            } catch {
                APIManager.request(ofType: type, didChangeStatus: .decodeFailed(url, error))
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
