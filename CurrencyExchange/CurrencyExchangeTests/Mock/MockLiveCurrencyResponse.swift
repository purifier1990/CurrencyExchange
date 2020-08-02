//
//  MockLiveCurrencyResponse.swift
//  CurrencyExchangeTests
//
//  Created by wenyu zhao on 2020/8/2.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import XCTest
@testable import CurrencyExchange

struct MockLiveCurrencyResponse {
    var success: Bool = true
    var terms: String = "www.test.com"
    var privacy: String = "www.test.com"
    var timestamp: Int = 15303230
    var source: String = "AFN"
    var quotes: [String: Float] = [
        "USDAED": 3.67295,
        "USDAFN": 76.703991
    ]
}
