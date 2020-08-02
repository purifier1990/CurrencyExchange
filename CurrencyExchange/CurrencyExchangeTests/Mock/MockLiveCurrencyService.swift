//
//  MockLiveCurrencyService.swift
//  CurrencyExchangeTests
//
//  Created by wenyu zhao on 2020/8/2.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import XCTest
@testable import CurrencyExchange

class MockLiveCurrencyService: LiveCurrencyAPI {
    var error: ServiceError?
    let mockResponse = MockLiveCurrencyResponse()
    
    func liveCurrencies(completion: @escaping (Result<LiveCurrency, ServiceError>) -> Void) {
        DispatchQueue.main.async {
            if let _ = self.error {
                completion(.failure(.unknownResponse))
            } else {
                completion(.success(LiveCurrency(success: self.mockResponse.success,
                terms: self.mockResponse.terms,
                privacy: self.mockResponse.privacy,
                timestamp: self.mockResponse.timestamp,
                source: self.mockResponse.source,
                quotes: self.mockResponse.quotes)))
            }
        }
    }
}
