//
//  SupportedCurrency.swift
//  CurrencyExchange
//
//  Created by wenyu zhao on 2020/7/29.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import Foundation

struct SupportedCurrency: Codable {
    var success: Bool
    var terms: String
    var privacy: String
    var currencies: [String: String]
}
