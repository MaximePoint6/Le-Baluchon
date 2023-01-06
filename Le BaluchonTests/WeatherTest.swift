//
//  WeatherTest.swift
//  Le BaluchonTests
//
//  Created by Maxime Point on 06/01/2023.
//

import XCTest
@testable import Le_Baluchon

final class WeatherTest: XCTestCase {
    
    var weather: Weather?
    
    override func setUpWithError() throws {
        UserSettings.userLanguage = .fr
        weather = try! SnakeCaseJSONDecoder().decode(Weather.self,
                                                                from: FakeResponseData.weatherCorrectData!)
    }
    
    func testWhenWeatherVariableInWeatherObjectIsEmpty() {
        weather!.weather = []
        
        let mainWeatherDescription = "-"
        
        XCTAssertEqual(mainWeatherDescription, weather!.mainWeatherDescription)
        XCTAssertNil(weather!.mainWeatherIcon)
    }
    
    func testWhenTemperatureIsEmpty() {
        weather!.main = nil
        
        let tempWithPreferredUnit: String? = nil
        let tempLabel = "-\(UserSettings.temperatureUnit.unit)"
        
        XCTAssertEqual(tempWithPreferredUnit, weather!.tempWithPreferredUnit)
        XCTAssertEqual(tempLabel, weather!.tempLabel)
    }
    
    func testWhenTimeZoneIsEmpty() {
        weather!.timezone = nil
        
        let timeZone = "-"
        
        XCTAssertEqual(timeZone, weather!.localDate)
    }
    
    func testWhenTemperatureUnitIsFahrenheit() {
        UserSettings.temperatureUnit = .Fahrenheit
        
        let mainTemp = String(format: "%.1f", Float((273.85 - 273.15) * (9/5) + 32))
        
        XCTAssertEqual(mainTemp, weather!.tempWithPreferredUnit)
    }
    
    func testWhenTemperatureUnitIsKelvin() {
        UserSettings.temperatureUnit = .Kelvin
        
        let mainTemp = String(format: "%.1f", Float(273.85))
        
        XCTAssertEqual(mainTemp, weather!.tempWithPreferredUnit)
    }
}
