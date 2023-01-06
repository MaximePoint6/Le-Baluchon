//
//  WeatherService.swift
//  Le Baluchon
//
//  Created by Maxime Point on 20/11/2022.
//

import Foundation

class WeatherService {
    
    static var shared = WeatherService()
    private init() {}
    
    private var session = URLSession(configuration: .default)
    init (session: URLSession) {
        self.session = session
    }
    
    private var task: URLSessionDataTask?
    
    /// Function performing a network call in order to get the city weather forecast.
    /// - Parameters:
    ///   - cityType: Desired city to retrieve his weather (type: current or destination).
    ///   - callback: Callback returning ServiceError? and a Weather?.
    func getWeather(cityType: CityType, callback: @escaping (ServiceError?, Weather?) -> Void) {
        
        task?.cancel()
        
        var lat: Double
        var lon: Double
        switch cityType {
            case .current:
                guard let currentCityLat = UserSettings.currentCity?.lat,
                        let currentCityLon = UserSettings.currentCity?.lon else {
                    callback(ServiceError.noCurrentCity, nil)
                    return
                }
                lat = currentCityLat
                lon = currentCityLon
            case .destination:
                guard let destinationCityLat = UserSettings.destinationCity?.lat,
                        let destinationCityLon = UserSettings.destinationCity?.lon else {
                    callback(ServiceError.noDestinationCity, nil)
                    return
                }
                lat = destinationCityLat
                lon = destinationCityLon
        }
        
        let lang = UserSettings.userLanguage.rawValue

        /// Construction of the url for the network call.
        var urlBuilder: URL? {
            let baseURL = "https://api.openweathermap.org/data/2.5/weather?"
            return URL(string: "\(baseURL)lat=\(String(lat))&lon=\(String(lon))&appid=\(ApiKey.oWeather)&lang=\(lang)")
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
                guard let responseJSON = try? SnakeCaseJSONDecoder().decode(Weather.self, from: data) else {
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
