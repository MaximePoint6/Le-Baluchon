//
//  LocationServiceTests.swift
//  LocationServiceTests
//
//  Created by Maxime Point on 18/11/2022.
//

import XCTest
@testable import Le_Baluchon

final class LocationServiceTests: XCTestCase {
    
    let city = "Paris"
    
    override func setUpWithError() throws {
        UserSettings.userLanguage = .fr
    }
    
    // test when the call returns an error
    func testgetLocationShouldPostFailedCallbackIfError() throws {
        // Given
        let locationService = CityService(session: URLSessionFake(data: FakeResponseData.locationCorrectData,
                                                                    response: FakeResponseData.responseKO,
                                                                    error: FakeResponseData.error))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        locationService.getCities(city: self.city) { error, location in
            // Then
            XCTAssertEqual(ServiceError.noData, error)
            XCTAssertNil(location)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when the call returns an incorrect response
    func testgetLocationShouldPostFailedCallbackIfIncorrectResponse() throws {
        // Given
        let locationService = CityService(session: URLSessionFake(data: FakeResponseData.locationCorrectData,
                                                                    response: FakeResponseData.responseKO,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        locationService.getCities(city: city) { error, location in
            // Then
            XCTAssertEqual(ServiceError.badResponse, error)
            XCTAssertNil(location)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when the call returns incorrect data
    func testgetLocationShouldPostFailedCallbackIfIncorrectData() throws {
        // Given
        let locationService = CityService(session: URLSessionFake(data: FakeResponseData.locationIncorrectData,
                                                                    response: FakeResponseData.responseOK,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        locationService.getCities(city: city) { error, location in
            // Then
            XCTAssertEqual(ServiceError.undecodableJSON, error)
            XCTAssertNil(location)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when call returns no data
    func testgetLocationShouldPostFailedCallbackIfNoData() throws {
        // Given
        let locationService = CityService(session: URLSessionFake(data: nil,
                                                                    response: nil,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        locationService.getCities(city: city) { error, location in
            // Then
            XCTAssertEqual(ServiceError.noData, error)
            XCTAssertNil(location)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when the call returns good data and a correct answer, without error
    func testgetLocationShouldPostFailedCallbackIfNoErrorAndCorrectData() throws {
        // Given
        let locationService = CityService(session: URLSessionFake(data: FakeResponseData.locationCorrectData,
                                                                    response: FakeResponseData.responseOK,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        locationService.getCities(city: city) { error, location in
            // Then
            XCTAssertNil(error)
            XCTAssertNotNil(location)
            
            let locationName = "Paris"
            let locationLocalName = "Paris"
            let locationCountry = "FR"
            let locationState = "Ile-de-France"
            
            let stateAndCountryDetails = "\(locationState), \(locationCountry)"
            let nameWithStateAndCountry = "\(locationLocalName), \(stateAndCountryDetails)"
            let localName = "Paris"
            
            XCTAssertEqual(locationName, location![0].name)
            XCTAssertEqual(locationLocalName, location![0].getLocalName(languageKeys: UserSettings.userLanguage))
            XCTAssertEqual(locationCountry, location![0].country)
            XCTAssertEqual(locationState, location![0].state)
            
            XCTAssertEqual(stateAndCountryDetails, location![0].stateAndCountryDetails)
            XCTAssertEqual(nameWithStateAndCountry,
                           location![0].getNameWithStateAndCountry(languageKeys: UserSettings.userLanguage))
            XCTAssertEqual(localName, location![0].getLocalName(languageKeys: UserSettings.userLanguage))
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
