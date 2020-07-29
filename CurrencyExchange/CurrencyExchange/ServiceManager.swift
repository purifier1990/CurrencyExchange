//
//  ServiceManager.swift
//  CurrencyExchange
//
//  Created by wenyu zhao on 2020/7/29.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import Foundation

protocol Service {
    func get(urlString: String, completion: @escaping (Result<Data, ServiceError>) -> Void)
}

class ServiceManager {
    static let shared = ServiceManager()
    let session: URLSession
    
    init() {
        session = URLSession(configuration: .default)
    }
    
    func get(urlString: String, completion: @escaping (Result<Data, ServiceError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL(url: urlString)))
            return
        }
    
        session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.requestError(errorString: error!.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
