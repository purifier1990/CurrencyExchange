//
//  ServiceError.swift
//  CurrencyExchange
//
//  Created by wenyu zhao on 2020/7/29.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case invalidURL(url: String)
    case invalidData
    case unknownResponse
    case requestError(errorString: String)
}
