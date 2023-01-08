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
    
    
    /// Function performing a network call in order to obtain the conversion of an amount.
    /// - Parameters:
    ///   - conversionFrom: Indicate the city / country from which the conversion must be done (current or destination).
    ///   - amount: Amount to be converted.
    ///   - callback: Callback returning ServiceError? and a Weather?.
    func getExchangeRateService(conversionFrom: CityType,
                                amount: Double,
                                callback: @escaping (ServiceError?, ExchangeRate?) -> Void) {

        task?.cancel()
        
        guard let currentCurrency = UserSettings.currentCity?.countryDetails?.currencies?[0].code,
              let destinationCurrency = UserSettings.destinationCity?.countryDetails?.currencies?[0].code else {
            callback(ServiceError.currencyNotFound, nil)
            return
        }
        
        /// Construction of the url for the network call.
        var urlBuilder: URL? {
            let amount = String(amount)
            let baseURL = "https://api.apilayer.com/fixer/convert?"
            switch conversionFrom {
                case .current:
                    return URL(string: "\(baseURL)to=\(destinationCurrency)&from=\(currentCurrency)&amount=\(amount)&apikey=\(ApiKey.apiLayer)")
                case .destination:
                    return URL(string: "\(baseURL)to=\(currentCurrency)&from=\(destinationCurrency)&amount=\(amount)&apikey=\(ApiKey.apiLayer)")
            }
        }
        
        guard let url = urlBuilder else { return callback(ServiceError.urlNotCorrect, nil) }
        
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
