//
//  MockListResponse.swift
//  CurrencyExchangeTests
//
//  Created by wenyu zhao on 2020/8/3.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import XCTest
@testable import CurrencyExchange

struct MockListResponse {
    var success: Bool = true
    var terms: String = "www.test.com"
    var privacy: String = "www.test.com"
    var currencies: [String: String] = [
        "AED": "United Arab Emirates Dirham",
        "AFN": "Afghan Afghani"
    ]
}
