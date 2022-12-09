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
        UserSettings.shared.userLanguage = .fr
    }
    
    
    // test when the call returns an error
    func testgetLocationShouldPostFailedCallbackIfError() throws {
        // Given
        let locationService = LocationService(session: URLSessionFake(data: FakeResponseData.locationCorrectData,
                                                                    response: FakeResponseData.responseKO,
                                                                    error: FakeResponseData.error))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        locationService.getLocation(city: self.city) { success, location in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(location)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when the call returns an incorrect response
    func testgetLocationShouldPostFailedCallbackIfIncorrectResponse() throws {
        // Given
        let locationService = LocationService(session: URLSessionFake(data: FakeResponseData.locationCorrectData,
                                                                    response: FakeResponseData.responseKO,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        locationService.getLocation(city: city) { success, location in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(location)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when the call returns incorrect data
    func testgetLocationShouldPostFailedCallbackIfIncorrectData() throws {
        // Given
        let locationService = LocationService(session: URLSessionFake(data: FakeResponseData.locationIncorrectData,
                                                                    response: FakeResponseData.responseKO,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        locationService.getLocation(city: city) { success, location in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(location)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when call returns no data
    func testgetLocationShouldPostFailedCallbackIfNoData() throws {
        // Given
        let locationService = LocationService(session: URLSessionFake(data: nil,
                                                                    response: nil,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        locationService.getLocation(city: city) { success, location in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(location)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when the call returns good data and a correct answer, without error
    func testgetLocationShouldPostFailedCallbackIfNoErrorAndCorrectData() throws {
        // Given
        let locationService = LocationService(session: URLSessionFake(data: FakeResponseData.locationCorrectData,
                                                                    response: FakeResponseData.responseOK,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        locationService.getLocation(city: city) { success, location in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(location)
            
            let locationName = "Paris"
            let locationLocalName = "Paris"
            let locationCountry = "FR"
            let locationState = "Ile-de-France"
            
            XCTAssertEqual(locationName, location![0].name)
            XCTAssertEqual(locationLocalName, location![0].getLocalName(languageKeys: UserSettings.shared.userLanguage))
            XCTAssertEqual(locationCountry, location![0].country)
            XCTAssertEqual(locationState, location![0].state)
            
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
