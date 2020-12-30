//
//  NLB-API.swift
//  NextBus
//
//  Created by Julian Schiavo on 21/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

struct NLBAPI: API {
    
    typealias APIError = APIManager.APIError
    typealias Priority = APIManager.Priority
    
    let baseURL: URL
    let companyID = CompanyID.nlb
    let backgroundQueue = DispatchQueue.global(qos: .userInteractive)
    
    init() {
        guard let baseURL = URL(string: "https://rt.data.gov.hk/v1/transport/nlb") else {
            fatalError("Mistyped URL")
        }
        self.baseURL = baseURL
    }
    
    // MARK: - Companies
    
    func fetchCompany(id: CompanyID, completion: @escaping (Result<Company, Error>) -> Void) {
        let company = Company(id: companyID, generated: Date(), englishName: "New Lantao Bus Company Limited", simplifiedChineseName: "新大屿山巴士有限公司", traditionalChineseName: "新大嶼山巴士有限公司")
        completion(.success(company))
    }
    
    // MARK: - Routes
    
    func fetchRoutes(companyID: CompanyID, route: String? = nil, urlSession: URLSession, completion: @escaping (Result<OrderedSet<Route>, Error>) -> Void) {
        let type = "FetchRoutes"
        
        let baseURL = self.baseURL.appendingPathComponent("/route.php")
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "action", value: "list")]
        guard let url = components?.url else { return }
        APIManager.request(ofType: type, didChangeStatus: .fetchStarting(url))
        
        let task = urlSession.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                APIManager.request(ofType: type, didChangeStatus: .fetchFailed(url, error))
                completion(.failure(error ?? APIError.failedToLoad))
                return
            }
            APIManager.request(ofType: type, didChangeStatus: .fetchSuccessful(url))
            
            let decoder = JSONDecoder()
            do {
                let rawRoute = try decoder.decode(NLBRawRoute.self, from: data)
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
        if includeCached || !APIManager.shared.hasCachedStops(for: route, in: .oneWay) {
            fetchStops(for: route, in: .oneWay, urlSession: urlSession) { result in
                switch result {
                case let .failure(error):
                    print(error)
                    completion(error)
                default:
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    struct StopRequestData: Codable {
        var routeId: String
    }
    
    func fetchStops(for route: Route, in direction: Direction, urlSession: URLSession, completion: @escaping (Result<OrderedSet<Stop>, Error>) -> Void) {
        let type = "FetchStops"
        
        guard direction == .oneWay else {
            fatalError("\(companyID) does not support multi-directional routes")
        }
        
        let baseURL = self.baseURL.appendingPathComponent("/stop.php")
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "action", value: "list")]
        guard let url = components?.url else { return }
        APIManager.request(ofType: type, didChangeStatus: .fetchStarting(url))
        
        let requestData = StopRequestData(routeId: route.id)
        var data: Data
        do {
            data = try JSONEncoder().encode(requestData)
        } catch {
            APIManager.request(ofType: type, didChangeStatus: .decodeFailed(url, error))
            completion(.failure(APIError.failedToLoad))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpBody = data
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                APIManager.request(ofType: type, didChangeStatus: .fetchFailed(url, error))
                completion(.failure(error ?? APIError.failedToLoad))
                return
            }
            APIManager.request(ofType: type, didChangeStatus: .fetchSuccessful(url))
            
            let decoder = JSONDecoder()
            do {
                let rawStop = try decoder.decode(NLBRawStop.self, from: data)
                let stops = rawStop.stops
                APIManager.shared.cache(stops, for: route, in: .oneWay)
                
                APIManager.request(ofType: type, didChangeStatus: .decodeSuccessful)
                completion(.success(stops))
            } catch {
                APIManager.request(ofType: type, didChangeStatus: .decodeFailed(url, error))
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: - ETA
    
    struct ETARequestData: Codable {
        var routeId: String
        var stopId: String
        var language: String = LocalizedText.nlbLanguageCode
    }
    
    func fetchETA(for route: Route, in direction: Direction, stop: Stop, urlSession: URLSession, completion: @escaping (Result<OrderedSet<ETA>, Error>) -> Void) {
        let type = "FetchETA"
        
        guard direction == .oneWay else {
            fatalError("\(companyID) does not support multi-directional routes")
        }
        
        let baseURL = self.baseURL.appendingPathComponent("/stop.php")
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "action", value: "estimatedArrivals")]
        guard let url = components?.url else { return }
        APIManager.request(ofType: type, didChangeStatus: .fetchStarting(url))
        
        let requestData = ETARequestData(routeId: route.id, stopId: stop.id)
        var data: Data
        do {
            data = try JSONEncoder().encode(requestData)
        } catch {
            APIManager.request(ofType: type, didChangeStatus: .decodeFailed(url, error))
            completion(.failure(APIError.failedToLoad))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpBody = data
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                APIManager.request(ofType: type, didChangeStatus: .fetchFailed(url, error))
                completion(.failure(error ?? APIError.failedToLoad))
                return
            }
            APIManager.request(ofType: type, didChangeStatus: .fetchSuccessful(url))
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(.dateSpaceTime)
            do {
                let rawETA = try decoder.decode(NLBRawETA.self, from: data)
                let etas = rawETA.etas(for: route)
                
                APIManager.request(ofType: type, didChangeStatus: .decodeSuccessful)
                completion(.success(etas))
            } catch {
                APIManager.request(ofType: type, didChangeStatus: .decodeFailed(url, error))
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
//    func fetchETA(for route: Route, in direction: Direction, stop: Stop, urlSession: URLSession, completion: @escaping (Result<OrderedSet<ETA>, Error>) -> Void) {
//        let url = baseURL.appendingPathComponent("/v1/transport/citybus-nwfb/eta/\(route.companyID)/\(stop.id)/\(route.name)")
//        print(url)
//        let task = urlSession.dataTask(with: url) { data, response, error in
//            print("Done", url)
//            guard let data = data, error == nil else {
//                completion(.failure(error ?? APIError.failedToLoad))
//                return
//            }
//            
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .iso8601
//            do {
//                let rawETA = try decoder.decode(NWFBCTBRawETA.self, from: data)
//                let etas = rawETA.etas(for: direction)
//                completion(.success(etas))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
}
