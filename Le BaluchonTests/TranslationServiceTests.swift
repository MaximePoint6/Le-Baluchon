//
//  TranslationServiceTests.swift
//  Le BaluchonTests
//
//  Created by Maxime Point on 05/01/2023.
//

import XCTest
@testable import Le_Baluchon

final class TranslationServiceTests: XCTestCase {
    
    let text: String = "Hello"
     
    override func setUpWithError() throws {
        // Ici mettre des données brutes
        let city = try! SnakeCaseJSONDecoder().decode([City].self, from: FakeResponseData.locationCorrectData!)
        UserSettings.currentCity = city[0]
        UserSettings.destinationCity = city[0]
        let countryDetails = try! SnakeCaseJSONDecoder().decode(City.CountryDetails.self,
                                                                from: FakeResponseData.countryCorrectData!)
        UserSettings.currentCity?.countryDetails = countryDetails
        UserSettings.destinationCity?.countryDetails = countryDetails
        UserSettings.userLanguage = .fr
    }
    
    
    // test when the call returns an error
    func testgetLocationShouldPostFailedCallbackIfError() throws {
        // Given
        let translationService = TranslationService(session: URLSessionFake(data: FakeResponseData.translationCorrectData,
                                                                    response: FakeResponseData.responseKO,
                                                                    error: FakeResponseData.error))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslationService(translationFrom: .current, text: text) { error, translation in
            // Then
            XCTAssertEqual(ServiceError.noData, error)
            XCTAssertNil(translation)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when the call returns an incorrect response
    func testgetLocationShouldPostFailedCallbackIfIncorrectResponse() throws {
        // Given
        let translationService = TranslationService(session: URLSessionFake(data: FakeResponseData.translationCorrectData,
                                                                    response: FakeResponseData.responseKO,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslationService(translationFrom: .current, text: text) { error, translation in
            // Then
            XCTAssertEqual(ServiceError.badResponse, error)
            XCTAssertNil(translation)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when the call returns incorrect data
    func testgetLocationShouldPostFailedCallbackIfIncorrectData() throws {
        // Given
        let translationService = TranslationService(session: URLSessionFake(data: FakeResponseData.translationIncorrectData,
                                                                    response: FakeResponseData.responseOK,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslationService(translationFrom: .current, text: text) { error, translation in
            // Then
            XCTAssertEqual(ServiceError.undecodableJSON, error)
            XCTAssertNil(translation)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when call returns no data
    func testgetLocationShouldPostFailedCallbackIfNoData() throws {
        // Given
        let translationService = TranslationService(session: URLSessionFake(data: nil,
                                                                    response: nil,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslationService(translationFrom: .current, text: text) { error, translation in
            // Then
            XCTAssertEqual(ServiceError.noData, error)
            XCTAssertNil(translation)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when the call returns good data and a correct answer, without error
    func testgetLocationShouldPostFailedCallbackIfNoErrorAndCorrectData() throws {
        // Given
        let translationService = TranslationService(session: URLSessionFake(data: FakeResponseData.translationCorrectData,
                                                                    response: FakeResponseData.responseOK,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslationService(translationFrom: .current, text: text) { error, translation in
            // Then
            XCTAssertNil(error)
            XCTAssertNotNil(translation)
            
            let result: String = "Bonjour"
            
            XCTAssertEqual(result, translation!.translations[0].text)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}


