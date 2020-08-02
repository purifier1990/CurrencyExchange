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
    var currencyCellModel: [CurrencyCellModel] { get set }
    var currentNumber: String { set get }
    var service: LiveCurrencyAPI { set get }
    
    func fetchLiveCurrencyRate()
    func calculateCovertedNumber(currentNumber: String, convertedCurrency: String) -> String
}

class CurrencyViewModel: CurrencyViewModelType {
    weak var viewModelObserver: ViewModelObserver?
    
    var service: LiveCurrencyAPI
    var baseCurrency = "USD" {
        didSet {
            if oldValue != baseCurrency {
                updateCurrencyCellModel()
            }
        }
    }
    var currencyList = [String]()
    var rateMap = [String: Double]()
    var currencyCellModel = [CurrencyCellModel]()
    var currentNumber = "100.0" {
        didSet {
            if oldValue != currentNumber {
                updateCurrencyCellModel()
            }
        }
    }
    
    init(_ service: LiveCurrencyAPI) {
        self.service = service
    }
    
    func fetchLiveCurrencyRate() {
        service.liveCurrencies { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.baseCurrency = response.source
                response.quotes.forEach { (key, value) in
                    self?.currencyList.append(String(key.suffix(3)))
                    self?.rateMap[String(key.suffix(3))] = Double(value)
                }
                self?.updateCurrencyCellModel()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateCurrencyCellModel() {
        currencyCellModel.removeAll()
        currencyList.forEach { (symbol) in
            if let converedRate = rateMap[symbol], let dependedRate = rateMap[baseCurrency] {
                currencyCellModel.append(CurrencyCellModel(currencySymbol: symbol,
                                                           currencyNumber: calculateCovertedNumber(currentNumber: currentNumber,
                                                                                                   convertedCurrency: symbol),
                                                           currencyRate: String(describing: (1.0 / dependedRate) * converedRate)))
            }
        }
        if let base = currencyCellModel.first(where: { $0.currencySymbol == baseCurrency }) {
            currencyCellModel.removeAll(where: { $0.currencySymbol == baseCurrency })
            currencyCellModel.insert(base, at: 0)
        }
        callObserver()
    }
    
    func calculateCovertedNumber(currentNumber: String, convertedCurrency: String) -> String {
        guard let number = Double(currentNumber), let rate = rateMap[convertedCurrency], let dependedRate = rateMap[baseCurrency] else {
            return ""
        }
        
        return String(describing: (number / dependedRate) * rate)
    }
}
