//
//  CountryService.swift
//  Le Baluchon
//
//  Created by Maxime Point on 30/12/2022.
//

import Foundation

class CountryService {
    
    static var shared = CountryService()
    private init() {}
    
    private var session = URLSession(configuration: .default)
    init (session: URLSession) {
        self.session = session
    }
    
    private var task: URLSessionDataTask?
    
    func getCountryDetails(cityType: CityType, callback: @escaping (ServiceError?, City.CountryDetails?) -> Void) {
        task?.cancel()
        
        var countryCode: String
        switch cityType {
            case .current:
                guard let currentCityCountry = UserSettings.currentCity?.country else {
                    callback(ServiceError.noCurrentCityCountry, nil)
                    return
                }
                countryCode = currentCityCountry
            case .destination:
                guard let destinationCityCountry = UserSettings.destinationCity?.country else {
                    callback(ServiceError.noDestinationCityCountry, nil)
                    return
                }
                countryCode = destinationCityCountry
        }

        var countryUrl: URL? {
            return URL(string: "https://restcountries.com/v2/alpha/\(countryCode)")
        }

        guard let url = countryUrl else { return callback(ServiceError.urlNotCorrect, nil) }

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
                guard let responseJSON = try? SnakeCaseJSONDecoder().decode(City.CountryDetails.self, from: data) else {
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
