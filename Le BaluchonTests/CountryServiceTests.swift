//
//  CountryServiceTests.swift
//  Le BaluchonTests
//
//  Created by Maxime Point on 05/01/2023.
//

import XCTest
@testable import Le_Baluchon

final class CountryServiceTests: XCTestCase {
    
    override func setUpWithError() throws {
        let city = try! SnakeCaseJSONDecoder().decode([City].self, from: FakeResponseData.locationCorrectData!)
        UserSettings.currentCity = city[0]
        UserSettings.destinationCity = city[0]
        UserSettings.userLanguage = .fr
    }
    
    // test when the call returns no currentCity
    func testgetWeatherShouldPostFailedCallbackIfNoCurrentCity() throws {
        UserSettings.currentCity = nil
        // Given
        let countryService = CountryService(session: URLSessionFake(data: FakeResponseData.weatherCorrectData,
                                                                    response: FakeResponseData.responseKO,
                                                                    error: FakeResponseData.error))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        countryService.getCountryDetails(cityType: .current) { error, countryDetails in
            // Then
            XCTAssertEqual(ServiceError.noCurrentCityCountry, error)
            XCTAssertNil(countryDetails)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when the call returns no destinationCity
    func testgetWeatherShouldPostFailedCallbackIfNoDestinationCity() throws {
        UserSettings.destinationCity = nil
        // Given
        let countryService = CountryService(session: URLSessionFake(data: FakeResponseData.weatherCorrectData,
                                                                    response: FakeResponseData.responseKO,
                                                                    error: FakeResponseData.error))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        countryService.getCountryDetails(cityType: .destination) { error, countryDetails in
            // Then
            XCTAssertEqual(ServiceError.noDestinationCityCountry, error)
            XCTAssertNil(countryDetails)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    // test when the call returns an error
    func testgetLocationShouldPostFailedCallbackIfError() throws {
        // Given
        let countryService = CountryService(session: URLSessionFake(data: FakeResponseData.countryCorrectData,
                                                                    response: FakeResponseData.responseKO,
                                                                    error: FakeResponseData.error))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        countryService.getCountryDetails(cityType: .current) { error, countryDetails in
            // Then
            XCTAssertEqual(ServiceError.noData, error)
            XCTAssertNil(countryDetails)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when the call returns an incorrect response
    func testgetLocationShouldPostFailedCallbackIfIncorrectResponse() throws {
        // Given
        let countryService = CountryService(session: URLSessionFake(data: FakeResponseData.countryCorrectData,
                                                                    response: FakeResponseData.responseKO,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        countryService.getCountryDetails(cityType: .current) { error, countryDetails in
            // Then
            XCTAssertEqual(ServiceError.badResponse, error)
            XCTAssertNil(countryDetails)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when the call returns incorrect data
    func testgetLocationShouldPostFailedCallbackIfIncorrectData() throws {
        // Given
        let countryService = CountryService(session: URLSessionFake(data: FakeResponseData.countryIncorrectData,
                                                                    response: FakeResponseData.responseOK,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        countryService.getCountryDetails(cityType: .current) { error, countryDetails in
            // Then
            XCTAssertEqual(ServiceError.undecodableJSON, error)
            XCTAssertNil(countryDetails)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when call returns no data
    func testgetLocationShouldPostFailedCallbackIfNoData() throws {
        // Given
        let countryService = CountryService(session: URLSessionFake(data: nil,
                                                                    response: nil,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        countryService.getCountryDetails(cityType: .destination) { error, countryDetails in
            // Then
            XCTAssertEqual(ServiceError.noData, error)
            XCTAssertNil(countryDetails)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when the call returns good data and a correct answer, without error
    func testgetLocationShouldPostFailedCallbackIfNoErrorAndCorrectData() throws {
        // Given
        let countryService = CountryService(session: URLSessionFake(data: FakeResponseData.countryCorrectData,
                                                                    response: FakeResponseData.responseOK,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        countryService.getCountryDetails(cityType: .current) { error, countryDetails in
            // Then
            XCTAssertNil(error)
            XCTAssertNotNil(countryDetails)
            
            let countryName = "France"
            let currencyName = "Euro"
            let currencySymbol = "€"
            let languagesCode = "fr"
            
            let currencyWithSymbol = "\(currencyName) - \(currencySymbol)"
            let languageNativeName = "français".capitalized
            
            XCTAssertEqual(countryName, countryDetails!.name)
            XCTAssertEqual(currencyName, countryDetails!.currencies![0].name)
            XCTAssertEqual(languagesCode, countryDetails!.languages![0].iso6391)
            
            UserSettings.currentCity!.countryDetails = countryDetails
            
            XCTAssertEqual(currencyWithSymbol, UserSettings.currentCity!.getCurrency)
            XCTAssertEqual(languageNativeName, UserSettings.currentCity!.getLanguage)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}

