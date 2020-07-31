//
//  Services.swift
//  CurrencyExchange
//
//  Created by wenyu zhao on 2020/7/29.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import Foundation

struct Services {
    func liveCurrencies(completion: @escaping (Result<LiveCurrency, ServiceError>) -> Void) {
        let baseEndPoint = BaseEndPoint(baseURL: Constans.baseUrl, relativePath: "live", queryParameters: ["access_key": Constans.apiKey])
        ServiceManager.shared.get(urlString: baseEndPoint.path) { result in
            switch result {
            case .success(let data):
                guard let liveCurrency = try? JSONDecoder().decode(LiveCurrency.self, from: data) else {
                    completion(.failure(.unknownResponse))
                    return
                }
                completion(.success(liveCurrency))
            case .failure(let error):
                completion(.failure(error))
                print(error)
            }
        }
    }
    
    func supportedCurrencies(completion: @escaping (Result<SupportedCurrency, ServiceError>) -> Void) {
        let baseEndPoint = BaseEndPoint(baseURL: Constans.baseUrl, relativePath: "list", queryParameters: ["access_key": Constans.apiKey])
        ServiceManager.shared.get(urlString: baseEndPoint.path) { result in
            switch result {
            case .success(let data):
                guard let supportedCurrency = try? JSONDecoder().decode(SupportedCurrency.self, from: data) else {
                    completion(.failure(.unknownResponse))
                    return
                }
                completion(.success(supportedCurrency))
            case .failure(let error):
                completion(.failure(error))
                print(error)
            }
        }
    }
}
