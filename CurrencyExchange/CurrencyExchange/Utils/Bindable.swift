//
//  Bindable.swift
//  CurrencyExchange
//
//  Created by wenyu zhao on 2020/7/31.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import Foundation
import UIKit

protocol Bindable: class {
    associatedtype ViewModelType
    var viewModel: ViewModelType? { get set }
}

extension Bindable where Self: UIViewController {
    func bind(to model: Self.ViewModelType) {
        viewModel = model
    }
}
