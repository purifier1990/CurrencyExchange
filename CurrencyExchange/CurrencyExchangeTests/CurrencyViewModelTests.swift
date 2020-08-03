//
//  CurrencyViewModelTests.swift
//  CurrencyExchangeTests
//
//  Created by wenyu zhao on 2020/8/2.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import XCTest
@testable import CurrencyExchange

class CurrencyViewModelTests: XCTestCase {
    var currencyViewModel: CurrencyViewModel!
    let serviceMock = MockLiveCurrencyService()
    
    override func setUp() {
        currencyViewModel = CurrencyViewModel(serviceMock)
    }
    
    func triggerLiveAPI(error: ServiceError? = nil) {
        let expectation = XCTestExpectation(description: "triggerLiveAPI")
        serviceMock.error = error
        currencyViewModel.fetchLiveCurrencyRate()
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.2) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testHappyCaseLiveCurrency() {
        triggerLiveAPI()
        XCTAssert(currencyViewModel.baseCurrency == "AFN")
        XCTAssert(currencyViewModel.rateMap == ["AED": 3.6729500293731689, "AFN": 76.703994750976563])
        XCTAssert(currencyViewModel.currentNumber == "100.0")
        XCTAssert(currencyViewModel.currencyList.count == 2)
    }
    
    func testUnhappyCaseLiveCurrency() {
        XCTAssert(currencyViewModel.hasError == false)
        triggerLiveAPI(error: .unknownResponse)
        XCTAssert(currencyViewModel.hasError == true)
    }
}
