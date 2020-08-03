//
//  MockListService.swift
//  CurrencyExchangeTests
//
//  Created by wenyu zhao on 2020/8/3.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import XCTest
@testable import CurrencyExchange

class MockListService: SupportedListAPI {
    var error: ServiceError?
    let mockResponse = MockListResponse()
    
    func supportedCurrencies(completion: @escaping (Result<SupportedCurrency, ServiceError>) -> Void) {
        if let error = self.error {
            completion(.failure(error))
        } else {
            completion(.success(SupportedCurrency(success: self.mockResponse.success,
                                                  terms: self.mockResponse.terms,
                                                  privacy: self.mockResponse.privacy,
                                                  currencies: self.mockResponse.currencies)))
        }
    }
}
