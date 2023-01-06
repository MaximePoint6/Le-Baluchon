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
        let city = try! SnakeCaseJSONDecoder().decode([City].self, from: FakeResponseData.locationCorrectData!)
        UserSettings.currentCity = city[0]
        UserSettings.destinationCity = city[0]
        UserSettings.userLanguage = .fr
        UserSettings.temperatureUnit = .Celsius
    }
    
    // test when the call returns no currentCity
    func testgetWeatherShouldPostFailedCallbackIfNoCurrentCity() throws {
        UserSettings.currentCity = nil
        // Given
        let weatherService = WeatherService(session: URLSessionFake(data: FakeResponseData.weatherCorrectData,
                                                                    response: FakeResponseData.responseKO,
                                                                    error: FakeResponseData.error))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(cityType: .current) { error, weather in
            // Then
            XCTAssertEqual(ServiceError.noCurrentCity, error)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test when the call returns no destinationCity
    func testgetWeatherShouldPostFailedCallbackIfNoDestinationCity() throws {
        UserSettings.destinationCity = nil
        // Given
        let weatherService = WeatherService(session: URLSessionFake(data: FakeResponseData.weatherCorrectData,
                                                                    response: FakeResponseData.responseKO,
                                                                    error: FakeResponseData.error))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(cityType: .destination) { error, weather in
            // Then
            XCTAssertEqual(ServiceError.noDestinationCity, error)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
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
        weatherService.getWeather(cityType: .destination) { error, weather in
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
            let mainTemp = String(format: "%.1f", Float((273.85) - 273.15))
            let tempLabel = "\(mainTemp)\(UserSettings.temperatureUnit.unit)"
            let localDate = DateFormater.getDate(timeZone: 3600)
            
            XCTAssertEqual(weatherDescription, weather!.mainWeatherDescription)
            XCTAssertEqual(weatherIcon, weather!.mainWeatherIcon)
            XCTAssertEqual(mainTemp, weather!.tempWithPreferredUnit)
            XCTAssertEqual(tempLabel, weather!.tempLabel)
            XCTAssertEqual(localDate, weather!.localDate)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
