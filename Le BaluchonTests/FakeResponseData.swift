//
//  FakeResponseData.swift
//  Le BaluchonTests
//
//  Created by Maxime Point on 09/12/2022.
//

import Foundation

class FakeResponseData {
    
    // MARK: Reponse simulation
    static let responseOK = HTTPURLResponse(url: URL(string: "https://api.openweathermap.org/data/2.5/")!,
                                            statusCode: 200,
                                            httpVersion: nil,
                                            headerFields: nil)!
    
    static let responseKO = HTTPURLResponse(url: URL(string: "https://api.openweathermap.org/data/2.5/")!,
                                            statusCode: 500,
                                            httpVersion: nil,
                                            headerFields: nil)!
    
    // MARK: Error simulation
    class QuoteError: Error { }
    static let error = QuoteError()
    
    
    // MARK: Location datas simulation
    static var locationCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Location", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
    
    static let locationIncorrectData = "erreur".data(using: .utf8)!
    
    
    // MARK: Weather datas simulation
    static var weatherCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Weather", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
    
    static let weatherIncorrectData = "erreur".data(using: .utf8)!
    
    // MARK: Country datas simulation
    static var countryCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Country", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
    
    static let countryIncorrectData = "erreur".data(using: .utf8)!
    
    // MARK: ExchangeRate datas simulation
    static var exchangeRateCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "ExchangeRate", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
    
    static let exchangeRateIncorrectData = "erreur".data(using: .utf8)!
    
    // MARK: Translation datas simulation
    static var translationCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Translation", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
    
    static let translationIncorrectData = "erreur".data(using: .utf8)!
    
}
