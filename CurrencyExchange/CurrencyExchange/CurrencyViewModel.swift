//
//  CurrencyViewModel.swift
//  CurrencyExchange
//
//  Created by wenyu zhao on 2020/7/30.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import Foundation

protocol Observer: class {
    func viewModelUpdated()
}

protocol CurrencyViewModelType {
    var baseCurrency: String { set get }
    var currencyList: [String] { set get }
    var currencyMap: [String: String] { set get }
    var rateMap: [String: Float] { set get }
}

class CurrencyViewModel: CurrencyViewModelType {
    var baseCurrency = "USD" {
        didSet {
            observer?.viewModelUpdated()
        }
    }
    var currencyList = [String]() {
        didSet {
            observer?.viewModelUpdated()
        }
    }
    var currencyMap = [String: String]() {
        didSet {
            observer?.viewModelUpdated()
        }
    }
    var rateMap = [String: Float]() {
        didSet {
            observer?.viewModelUpdated()
        }
    }
    
    weak var observer: Observer?
}
