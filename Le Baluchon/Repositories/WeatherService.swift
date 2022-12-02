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

    var lat = 44.34
    var lon = 10.99
    var lang = "fr"

    private var weatherUrl: URL {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(String(lat))&lon=\(String(lon))&appid=\(ApiKey.openWeather)&lang=\(lang)")!
    }

    private var session = URLSession(configuration: .default)
    private var task: URLSessionDataTask?

    func getWeather(callback: @escaping (Bool, Weather?) -> Void) {
        
        // faire peut etre ici les guard let de lat et lon
        
        task?.cancel()
        task = session.dataTask(with: weatherUrl) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                guard let responseJSON = try? SnakeCaseJSONDecoder().decode(Weather.self, from: data) else {
                    callback(false, nil)
                    return
                }
                print(data)
                print(response)
                print(responseJSON)
                callback(true, responseJSON)
            }
        }
        task?.resume()
    }

}
