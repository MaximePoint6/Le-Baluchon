//
//  ExchangeRateServiceTests.swift
//  Le BaluchonTests
//
//  Created by Maxime Point on 05/01/2023.
//

import XCTest
@testable import Le_Baluchon

final class ExchangeRateServiceTests: XCTestCase {
    
    let amount: Double = 10
    
    override func setUpWithError() throws {
        let city = try! SnakeCaseJSONDecoder().decode([City].self, from: FakeResponseData.locationCorrectData!)
        UserSettings.currentCity = city[0]
        UserSettings.destinationCity = city[0]
        let countryDetails = try! SnakeCaseJSONDecoder().decode(City.CountryDetails.self,
                                                                from: FakeResponseData.countryCorrectData!)
        UserSettings.currentCity?.countryDetails = countryDetails
        UserSettings.destinationCity?.countryDetails = countryDetails
        UserSettings.userLanguage = .fr
    }
    
    // test when the call returns no currentCity
    func testgetWeatherShouldPostFailedCallbackIfNoCurrentCity() throws {
        UserSettings.currentCity = nil
        // Given
        let exchangeRateService = ExchangeRateService(session: URLSessionFake(data: FakeResponseData.weatherCorrectData,
                                                                    response: FakeResponseData.responseKO,
                                                                    error: FakeResponseData.error))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRateService.getExchangeRateService(conversionFrom: .destination, amount: amount) { error, exchangeRate in
            // Then
            XCTAssertEqual(ServiceError.currencyNotFound, error)
            XCTAssertNil(exchangeRate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when the call returns no destinationCity
    func testgetWeatherShouldPostFailedCallbackIfNoDestinationCity() throws {
        UserSettings.destinationCity = nil
        // Given
        let exchangeRateService = ExchangeRateService(session: URLSessionFake(data: FakeResponseData.weatherCorrectData,
                                                                    response: FakeResponseData.responseKO,
                                                                    error: FakeResponseData.error))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRateService.getExchangeRateService(conversionFrom: .current, amount: amount) { error, exchangeRate in
            // Then
            XCTAssertEqual(ServiceError.currencyNotFound, error)
            XCTAssertNil(exchangeRate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    // test when the call returns an error
    func testgetLocationShouldPostFailedCallbackIfError() throws {
        // Given
        let exchangeRateService = ExchangeRateService(session: URLSessionFake(data: FakeResponseData.exchangeRateCorrectData,
                                                                    response: FakeResponseData.responseKO,
                                                                    error: FakeResponseData.error))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRateService.getExchangeRateService(conversionFrom: .current, amount: amount) { error, exchangeRate in
            // Then
            XCTAssertEqual(ServiceError.noData, error)
            XCTAssertNil(exchangeRate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when the call returns an incorrect response
    func testgetLocationShouldPostFailedCallbackIfIncorrectResponse() throws {
        // Given
        let exchangeRateService = ExchangeRateService(session: URLSessionFake(data: FakeResponseData.exchangeRateCorrectData,
                                                                    response: FakeResponseData.responseKO,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRateService.getExchangeRateService(conversionFrom: .current, amount: amount) { error, exchangeRate in
            // Then
            XCTAssertEqual(ServiceError.badResponse, error)
            XCTAssertNil(exchangeRate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when the call returns incorrect data
    func testgetLocationShouldPostFailedCallbackIfIncorrectData() throws {
        // Given
        let exchangeRateService = ExchangeRateService(session: URLSessionFake(data: FakeResponseData.exchangeRateIncorrectData,
                                                                    response: FakeResponseData.responseOK,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRateService.getExchangeRateService(conversionFrom: .current, amount: amount) { error, exchangeRate in
            // Then
            XCTAssertEqual(ServiceError.undecodableJSON, error)
            XCTAssertNil(exchangeRate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when call returns no data
    func testgetLocationShouldPostFailedCallbackIfNoData() throws {
        // Given
        let exchangeRateService = ExchangeRateService(session: URLSessionFake(data: nil,
                                                                    response: nil,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRateService.getExchangeRateService(conversionFrom: .destination, amount: amount) { error, exchangeRate in
            // Then
            XCTAssertEqual(ServiceError.noData, error)
            XCTAssertNil(exchangeRate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when the call returns good data and a correct answer, without error
    func testgetLocationShouldPostFailedCallbackIfNoErrorAndCorrectData() throws {
        // Given
        let exchangeRateService = ExchangeRateService(session: URLSessionFake(data: FakeResponseData.exchangeRateCorrectData,
                                                                    response: FakeResponseData.responseOK,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRateService.getExchangeRateService(conversionFrom: .current, amount: amount) { error, exchangeRate in
            // Then
            XCTAssertNil(error)
            XCTAssertNotNil(exchangeRate)
            
            let result: Double = 5.1961
            let resultText = String(floor(result * 100) / 100)
            
            XCTAssertEqual(result, exchangeRate!.result!)
            XCTAssertEqual(resultText, exchangeRate!.resultText)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}

