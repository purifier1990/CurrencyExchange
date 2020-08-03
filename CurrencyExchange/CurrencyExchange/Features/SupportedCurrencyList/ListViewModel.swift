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
    var service: SupportedListAPI { get set }
    var hasError: Bool { get set }
    
    func fetchSupportedCurrencies()
}

class ListViewModel: ListViewModelType {
    weak var viewModelObserver: ViewModelObserver?
    
    var service: SupportedListAPI
    var supportedCurrencies = [String]() {
        didSet {
            callObserver()
        }
    }
    var hasError: Bool = false {
        didSet {
            callObserver()
        }
    }
    
    init(_ service: SupportedListAPI) {
        self.service = service
    }
    
    func fetchSupportedCurrencies() {
        service.supportedCurrencies { [weak self] (result) in
            switch result {
            case .success(let list):
                self?.supportedCurrencies = Array(list.currencies.map { String("\($0.key):  \($0.value)") })
            case .failure(_):
                self?.hasError = true
            }
        }
    }
}
