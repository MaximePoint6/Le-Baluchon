//
//  LocationService.swift
//  Le Baluchon
//
//  Created by Maxime Point on 25/11/2022.
//

import Foundation

class LocationService {

    static var shared = LocationService()
    private init() {}

    private var session = URLSession(configuration: .default)
    private var task: URLSessionDataTask?

    func getLocation(city: String, callback: @escaping (Bool, [City]?) -> Void) {
        task?.cancel()
        
        let numberOfLocation = 5
//        var city = UserSettings.shared.userLanguage.rawValue

        var locationUrl: URL? {
            if let cityForUrl = city.encodingURL() {
                // TODO: encodingURL juste sur city... et si APIKey n'est pas conforme au type URL par exemple ca va crasher
                return URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(cityForUrl)&limit=\(numberOfLocation)&appid=\(ApiKey.openWeather)")
            }
            return nil
        }

        guard let url = locationUrl else { return callback(false, nil) }
        
        task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
//                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                guard let responseJSON = try? SnakeCaseJSONDecoder().decode([City].self, from: data) else {
                    callback(false, nil)
                    return
                }
                callback(true, responseJSON)
            }
        }
        task?.resume()
    }

}
