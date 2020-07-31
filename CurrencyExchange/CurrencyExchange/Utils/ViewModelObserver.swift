//
//  ViewModelObserver.swift
//  CurrencyExchange
//
//  Created by wenyu zhao on 2020/7/31.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

protocol ViewModelObservable: class {
    var viewModelObserver: ViewModelObserver? { get set }
}

protocol ViewModelObserver: class {
    func viewModelUpdated(_ viewModel: ViewModelObservable)
}

extension ViewModelObservable {
    func callObserver() {
        viewModelObserver?.viewModelUpdated(self)
    }
}
