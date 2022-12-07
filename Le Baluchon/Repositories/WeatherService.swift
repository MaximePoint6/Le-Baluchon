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
    
    // TODO: peut-on récupérer directement les datas dans un autre model ? dans UserSettings.shared ?
    // Si oui, dans ce cas la il faut que je gere le cas quand c'est currentCity ou destination City qu'on souhaite.
    // Mettre ces variables (lat, lon, land, weatherURL) dans le getWeather, et demander en parametres le CityType puis faire un switch ?
    // Pour que ça soit homogene faire pareil dans LocationService, mettre les variables dans le getLocation.
    // D'un point de vue perf est-ce mieux que les variables soient stockées dans la classe ou dans la fonction ?
    var lat = 44.34
    var lon = 10.99
    var lang = "fr"

    private var weatherUrl: URL {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(String(lat))&lon=\(String(lon))&appid=\(ApiKey.openWeather)&lang=\(lang)")!
    }
    
    private var session = URLSession(configuration: .default)
    private var task: URLSessionDataTask?
    
    func getWeather(callback: @escaping (Bool, Weather?) -> Void) {
        task?.cancel()
        
//        // si on met ça ici, penser à mettre en parametre cityType dans getWeather dans ce cas
//        var lat: Double
//        var lon: Double
//        switch cityType {
//            case .current:
//                guard let currentCityLat = UserSettings.shared.currentCity?.lat,
//                        let currentCityLon = UserSettings.shared.currentCity?.lon else {
//                    callback(false, nil)
//                    return
//                }
//                lat = currentCityLat
//                lon = currentCityLon
//            case .destination:
//                guard let destinationCityLat = UserSettings.shared.destinationCity?.lat,
//                        let destinationCityLon = UserSettings.shared.destinationCity?.lon else {
//                    callback(false, nil)
//                    return
//                }
//                lat = destinationCityLat
//                lon = destinationCityLon
//        }
//        var lang = UserSettings.shared.userLanguage.rawValue
//
//        var weatherUrl: URL? {
//            return URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(String(lat))&lon=\(String(lon))&appid=\(ApiKey.openWeather)&lang=\(lang)")
//        }
//
//        guard let url = weatherUrl else { return callback(false, nil) }

        task = session.dataTask(with: weatherUrl) { (data, response, error) in
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
