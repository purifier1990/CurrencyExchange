//
//  CurrencyViewModel.swift
//  CurrencyExchange
//
//  Created by wenyu zhao on 2020/7/30.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import Foundation

protocol CurrencyViewModelType: ViewModelObservable {
    var baseCurrency: String { set get }
    var currencyList: [String] { set get }
    var rateMap: [String: Double] { set get }
    
    func fetchLiveCurrencyRate()
    func calculateCovertedNumber(currentNumber: String, convertedCurrency: String) -> String
}

class CurrencyViewModel: CurrencyViewModelType {
    weak var viewModelObserver: ViewModelObserver?
    
    var baseCurrency = "USD" {
        didSet {
            callObserver()
        }
    }
    var currencyList = [String]() {
        didSet {
            callObserver()
        }
    }
    var rateMap = [String: Double]() {
        didSet {
            callObserver()
        }
    }
    
    func fetchLiveCurrencyRate() {
        Services().liveCurrencies { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.baseCurrency = response.source
                response.quotes.forEach { (key, value) in
                    self?.currencyList.append(String(key.suffix(3)))
                    self?.rateMap[String(key.suffix(3))] = Double(value)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func calculateCovertedNumber(currentNumber: String, convertedCurrency: String) -> String {
        guard let number = Double(currentNumber), let rate = rateMap[convertedCurrency], let dependedRate = rateMap[baseCurrency] else {
            return ""
        }
        
        return String(describing: (number / dependedRate) * rate)
    }
}
