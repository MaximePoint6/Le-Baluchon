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
    init (session: URLSession) {
        self.session = session
    }
    
    private var task: URLSessionDataTask?

    func getLocation(city: String, callback: @escaping (ServiceError?, [City]?) -> Void) {
        task?.cancel()
        
        let numberOfLocation = 5

        var locationUrl: URL? {
            if let cityForUrl = city.encodingURL() {
                return URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(cityForUrl)&limit=\(numberOfLocation)&appid=\(ApiKey.openWeather)")
            }
            return nil
        }

        guard let url = locationUrl else { return callback(ServiceError.urlNotCorrect, nil) }
        
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
