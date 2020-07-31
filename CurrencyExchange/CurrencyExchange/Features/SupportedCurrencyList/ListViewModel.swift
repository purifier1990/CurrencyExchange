//
//  ListViewModel.swift
//  CurrencyExchange
//
//  Created by wenyu zhao on 2020/7/31.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import Foundation

protocol ListViewModelType: ViewModelObservable {
    var supportedCurrencies: [String] { get set }
    func fetchSupportedCurrencies()
}

class ListViewModel: ListViewModelType {
    weak var viewModelObserver: ViewModelObserver?
    
    var supportedCurrencies = [String]() {
        didSet {
            callObserver()
        }
    }
    
    func fetchSupportedCurrencies() {
        Services().supportedCurrencies { [weak self] (result) in
            switch result {
            case .success(let list):
                self?.supportedCurrencies = Array(list.currencies.map { String("\($0.key):  \($0.value)") })
            case .failure(let error):
                print(error)
            }
        }
    }
}
