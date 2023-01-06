//
//  ExchangeRateTest.swift
//  Le BaluchonTests
//
//  Created by Maxime Point on 06/01/2023.
//

import XCTest
@testable import Le_Baluchon

final class ExchangeRateTest: XCTestCase {
    
    var exchangeRate: ExchangeRate?
    
    override func setUpWithError() throws {
        exchangeRate = try! SnakeCaseJSONDecoder().decode(ExchangeRate.self,
                                                                from: FakeResponseData.exchangeRateCorrectData!)
    }
    
    func testWhenExchangeRateResultIsEmpty() {
        exchangeRate!.result = nil
        let resultText = "-"
        
        XCTAssertEqual(resultText, exchangeRate?.resultText)
    }
    
    
}
