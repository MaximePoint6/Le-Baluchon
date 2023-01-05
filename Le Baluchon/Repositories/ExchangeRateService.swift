//
//  exchangeRateService.swift
//  Le Baluchon
//
//  Created by Maxime Point on 01/01/2023.
//

import Foundation

class ExchangeRateService {
    
    static var shared = ExchangeRateService()
    private init() {}
    
    private var session = URLSession(configuration: .default)
    init (session: URLSession) {
        self.session = session
    }
    
    private var task: URLSessionDataTask?
    
    func getExchangeRateService(conversionFrom: CityType, amount: Double,
                                callback: @escaping (ServiceError?, ExchangeRate?) -> Void) {
        task?.cancel()
        
        guard let currencyCurrentCity = UserSettings.currentCity?.countryDetails?.currencies?[0].code,
              let currencyDestinationCity = UserSettings.destinationCity?.countryDetails?.currencies?[0].code else {
            callback(ServiceError.currencyNotFound, nil)
            return
        }
        
        
        var exchangeRateUrl: URL? {
            switch conversionFrom {
                case .current:
                    return URL(string: "https://api.apilayer.com/fixer/convert?to=\(currencyDestinationCity)&from=\(currencyCurrentCity)&amount=\(String(amount))&apikey=\(ApiKey.apiLayer)")
                case .destination:
                    return URL(string: "https://api.apilayer.com/fixer/convert?to=\(currencyCurrentCity)&from=\(currencyDestinationCity)&amount=\(String(amount))&apikey=\(ApiKey.apiLayer)")
            }
        }
        
        guard let url = exchangeRateUrl else { return callback(ServiceError.urlNotCorrect, nil) }
        
        task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(ServiceError.noData, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(ServiceError.badResponse, nil)
                    return
                }
                guard let responseJSON = try? SnakeCaseJSONDecoder().decode(ExchangeRate.self, from: data) else {
                    callback(ServiceError.undecodableJSON, nil)
                    return
                }
                print(data)
                print(response)
                print(responseJSON)
                callback(nil, responseJSON)
            }
        }
        task?.resume()
    }
    
}
