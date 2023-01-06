//
//  CityService.swift
//  Le Baluchon
//
//  Created by Maxime Point on 25/11/2022.
//

import Foundation

class CityService {

    static var shared = CityService()
    private init() {}
    
    private var session = URLSession(configuration: .default)
    init (session: URLSession) {
        self.session = session
    }
    
    private var task: URLSessionDataTask?
    
    /// Function executing a network call in order to get a list of cities,
    /// named according to the city sent in function parameters (or starting with the same letters).
    /// - Parameters:
    ///   - city: Part or full name of a city.
    ///   - callback: Callback returning ServiceError? and a [City]?.
    func getCities(city: String, callback: @escaping (ServiceError?, [City]?) -> Void) {
        
        task?.cancel()

        let numberOfCities = 5

        /// Construction of the url for the network call (verification if the user data can be encoded for a url).
        var urlBuilder: URL? {
            if let cityForUrl = city.encodingURL() {
                let baseURL = "https://api.openweathermap.org/geo/1.0/direct?"
                return URL(string: "\(baseURL)q=\(cityForUrl)&limit=\(numberOfCities)&appid=\(ApiKey.oWeather)")
            } else { return nil }
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
                guard let responseJSON = try? SnakeCaseJSONDecoder().decode([City].self, from: data) else {
                    callback(ServiceError.undecodableJSON, nil)
                    return
                }
                callback(nil, responseJSON)
            }
        }
        task?.resume()
    }

}
