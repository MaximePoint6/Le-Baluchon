//
//  WeatherServiceTests.swift
//  WeatherServiceTests
//
//  Created by Maxime Point on 18/11/2022.
//

import XCTest
@testable import Le_Baluchon

final class WeatherServiceTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Ici mettre des données brutes
        let city = try! SnakeCaseJSONDecoder().decode([City].self, from: FakeResponseData.locationCorrectData!)
        UserSettings.currentCity = city[0]
        UserSettings.destinationCity = city[0]
        UserSettings.userLanguage = .fr
    }
    
    
    // test when the call returns an error
    func testgetWeatherShouldPostFailedCallbackIfError() throws {
        // Given
        let weatherService = WeatherService(session: URLSessionFake(data: FakeResponseData.weatherCorrectData,
                                                                    response: FakeResponseData.responseKO,
                                                                    error: FakeResponseData.error))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(cityType: .current) { error, weather in
            // Then
            XCTAssertEqual(ServiceError.noData, error)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when the call returns an incorrect response
    func testgetWeatherShouldPostFailedCallbackIfIncorrectResponse() throws {
        // Given
        let weatherService = WeatherService(session: URLSessionFake(data: FakeResponseData.weatherCorrectData,
                                                                    response: FakeResponseData.responseKO,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(cityType: .current) { error, weather in
            // Then
            XCTAssertEqual(ServiceError.badResponse, error)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when the call returns incorrect data
    func testgetWeatherShouldPostFailedCallbackIfIncorrectData() throws {
        // Given
        let weatherService = WeatherService(session: URLSessionFake(data: FakeResponseData.weatherIncorrectData,
                                                                    response: FakeResponseData.responseOK,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(cityType: .current) { error, weather in
            // Then
            XCTAssertEqual(ServiceError.undecodableJSON, error)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when call returns no data
    func testgetWeatherShouldPostFailedCallbackIfNoData() throws {
        // Given
        let weatherService = WeatherService(session: URLSessionFake(data: nil,
                                                                    response: nil,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(cityType: .current) { error, weather in
            // Then
            XCTAssertEqual(ServiceError.noData, error)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when the call returns good data and a correct answer, without error
    func testgetWeatherShouldPostFailedCallbackIfNoErrorAndCorrectData() throws {
        // Given
        let weatherService = WeatherService(session: URLSessionFake(data: FakeResponseData.weatherCorrectData,
                                                                    response: FakeResponseData.responseOK,
                                                                    error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(cityType: .current) { error, weather in
            // Then
            XCTAssertNil(error)
            XCTAssertNotNil(weather)
            
            let weatherDescription = "couvert"
            let weatherIcon = "04d"
            let mainTemp = 273.85
            
            XCTAssertEqual(weatherDescription, weather!.weather[0].description)
            XCTAssertEqual(weatherIcon, weather!.weather[0].icon)
            XCTAssertEqual(mainTemp, weather!.main!.temp)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
