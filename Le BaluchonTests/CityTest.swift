//
//  CityTest.swift
//  Le BaluchonTests
//
//  Created by Maxime Point on 06/01/2023.
//

import XCTest
@testable import Le_Baluchon

final class CityTest: XCTestCase {
    
    var city: [City]?
    
    override func setUpWithError() throws {
        city = try! SnakeCaseJSONDecoder().decode([City].self, from: FakeResponseData.locationCorrectData!)
        let countryDetails = try! SnakeCaseJSONDecoder().decode(City.CountryDetails.self,
                                                                from: FakeResponseData.countryCorrectData!)
        city![0].countryDetails = countryDetails
    }
    
    func testWhenCountryVariableInCityObjectIsEmpty() {
        city![0].country = nil
        
        let name = "Paris"
        let localName = "Paris"
        let state = "Ile-de-France"
        
        let stateAndCountryDetails = state
        let nameWithStateAndCountry = "\(localName), \(stateAndCountryDetails)"

        
        XCTAssertEqual(stateAndCountryDetails, city![0].stateAndCountryDetails)
        XCTAssertEqual(nameWithStateAndCountry,
                       city![0].getNameWithStateAndCountry(languageKeys: UserSettings.userLanguage))
    }
    
    func testWhenStateVariableInCityObjectIsEmpty() {
        city![0].state = nil
        
        let name = "Paris"
        let localName = "Paris"
        let country = "FR"
        
        let stateAndCountryDetails = country
        let nameWithStateAndCountry = "\(localName), \(stateAndCountryDetails)"

        
        XCTAssertEqual(stateAndCountryDetails, city![0].stateAndCountryDetails)
        XCTAssertEqual(nameWithStateAndCountry,
                       city![0].getNameWithStateAndCountry(languageKeys: UserSettings.userLanguage))
    }
    
    func testWhenStateAndCountryVariableInCityObjectIsEmpty() {
        city![0].country = nil
        city![0].state = nil
        
        let name = "Paris"
        let localName = "Paris"
        
        let stateAndCountryDetails = ""
        let nameWithStateAndCountry = localName

        
        XCTAssertEqual(stateAndCountryDetails, city![0].stateAndCountryDetails)
        XCTAssertEqual(nameWithStateAndCountry,
                       city![0].getNameWithStateAndCountry(languageKeys: UserSettings.userLanguage))
    }
    
    func testWhenCurrenciesInCountryDetailsObjectIsEmpty() {
        city![0].countryDetails?.currencies = nil
        
        let currencyText = "unknown.currency".localized()
        
        XCTAssertEqual(currencyText, city![0].getCurrency)
    }
    
    func testWhenCurrencySymbolInCountryDetailsObjectIsEmpty() {
        city![0].countryDetails?.currencies![0].symbol = nil
        
        let currency = city![0].countryDetails?.currencies![0].name
        let currencyText = currency
        
        XCTAssertEqual(currencyText, city![0].getCurrency)
    }
    
    func testWhenlanguagesInCountryDetailsObjectIsEmpty() {
        city![0].countryDetails?.languages = nil
        
        let languageText = "unknown.language".localized()
        
        XCTAssertEqual(languageText, city![0].getLanguage)
    }
    
    func testWhenNameInCityObjectIsEmpty() {
        city![0].name = nil
        
        let localName = "no.city.name".localized()
        
        XCTAssertEqual(localName, city![0].getLocalName(languageKeys: UserSettings.userLanguage))
    }
    
    func testWhenUserLanguageIsEnglishForGetLocalNameFunction() {
        UserSettings.userLanguage = .en
        
        let localName = "Paris"
        
        XCTAssertEqual(localName, city![0].getLocalName(languageKeys: UserSettings.userLanguage))
    }
    
    func testWhenLocalNameOfUserLanguageInLocalNamesObjectIsEmpty() {
        UserSettings.userLanguage = .en
        city![0].localNames?.en = nil
        
        let nameOfCity = "Paris"
        
        XCTAssertEqual(nameOfCity, city![0].getLocalName(languageKeys: UserSettings.userLanguage))
    }
}
