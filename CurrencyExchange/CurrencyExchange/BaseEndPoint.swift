//
//  BaseEndPoint.swift
//  CurrencyExchange
//
//  Created by wenyu zhao on 2020/7/29.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import Foundation

class BaseEndPoint {
    var path: String
    let baseURL: String
    let relativePath: String
    let queryParameters: [String: String]?
    
    init(baseURL: String, relativePath: String, queryParameters: [String: String]? = nil) {
        self.baseURL = baseURL
        self.relativePath = relativePath
        self.queryParameters = queryParameters
        self.path = "\(baseURL)\(relativePath)"
        
        guard let queryParameters = queryParameters else {
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = queryParameters.map({ URLQueryItem(name: $0, value: $1) })
        
        if let queryString = urlComponents.percentEncodedQuery {
            path += "?\(queryString)"
        }
    }
}
