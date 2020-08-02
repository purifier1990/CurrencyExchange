//
//  ViewModelObserverTests.swift
//  CurrencyExchangeTests
//
//  Created by wenyu zhao on 2020/8/2.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import XCTest
@testable import CurrencyExchange

class ViewModelObserverTests: XCTestCase {
    class Observee: ViewModelObservable {
        var viewModelObserver: ViewModelObserver?
    }
    
    class Observer: ViewModelObserver {
        var testValue = false
        func viewModelUpdated(_ viewModel: ViewModelObservable) {
            testValue = true
        }
    }
    
    func testViewModelUpdated() {
        let observee = Observee()
        let observer = Observer()
        observee.viewModelObserver = observer
        
        observee.callObserver()
        XCTAssert(observer.testValue == true)
    }
}
