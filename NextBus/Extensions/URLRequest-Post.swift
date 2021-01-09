//
//  URLRequest-Post.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/12/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import Foundation

extension URLRequest {
    /// The name of the HTTP content type header
    private static let contentTypeHeader = "Content-Type"
    
    /// The name of the JSON content type
    private static let contentTypeJSON = "application/json"
    
    /// The name of the HTTP POST method
    private static let postMethod = "POST"
    
    /// Creates a POST URL request with a JSON body
    /// - Parameters:
    ///   - url: The URL for the request
    ///   - body: The body for the request
    /// - Returns: The request
    static func postRequest<T: Encodable>(url: URL, body: T) -> URLRequest {
        let encodedBody = (try? JSONEncoder().encode(body)) ?? Data()
        
        var request = URLRequest(url: url)
        request.httpBody = encodedBody
        
        request.httpMethod = postMethod
        request.addValue(contentTypeJSON, forHTTPHeaderField: contentTypeHeader)
        
        return request
    }
}
