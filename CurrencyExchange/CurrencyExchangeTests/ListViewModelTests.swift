//
//  ListViewModelTests.swift
//  CurrencyExchangeTests
//
//  Created by wenyu zhao on 2020/8/3.
//  Copyright © 2020 Ryan zhao. All rights reserved.
//

import XCTest
@testable import CurrencyExchange

class ListViewModelTests: XCTestCase {
    var listViewModel: ListViewModel!
    let serviceMock = MockListService()
    
    override func setUp() {
        listViewModel = ListViewModel(serviceMock)
    }
    
    func triggerListAPI(error: ServiceError? = nil) {
        let expectation = XCTestExpectation(description: "triggerListAPI")
        serviceMock.error = error
        listViewModel.fetchSupportedCurrencies()
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.2) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testHappyCaseList() {
        triggerListAPI()
        print(listViewModel.supportedCurrencies)
        XCTAssert(listViewModel.supportedCurrencies.count == 2)
    }
    
    func testUnhappyCaseLiveList() {
        XCTAssert(listViewModel.hasError == false)
        triggerListAPI(error: .unknownResponse)
        XCTAssert(listViewModel.hasError == true)
    }
}
