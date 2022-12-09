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
    
    func getWeather(cityType: CityType, callback: @escaping (Bool, Weather?) -> Void) {
        task?.cancel()
        
        var lat: Double
        var lon: Double
        switch cityType {
            case .current:
                guard let currentCityLat = UserSettings.shared.currentCity?.lat,
                        let currentCityLon = UserSettings.shared.currentCity?.lon else {
                    callback(false, nil)
                    return
                }
                lat = currentCityLat
                lon = currentCityLon
            case .destination:
                guard let destinationCityLat = UserSettings.shared.destinationCity?.lat,
                        let destinationCityLon = UserSettings.shared.destinationCity?.lon else {
                    callback(false, nil)
                    return
                }
                lat = destinationCityLat
                lon = destinationCityLon
        }
        var lang = UserSettings.shared.userLanguage.rawValue

        var weatherUrl: URL? {
            return URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(String(lat))&lon=\(String(lon))&appid=\(ApiKey.openWeather)&lang=\(lang)")
        }

        guard let url = weatherUrl else { return callback(false, nil) }

        task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    // TODO: Faire gestion des erreurs plus précise avec une enum détaillée pour l'afficher dans les alertes, pareil pour Location Service
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
