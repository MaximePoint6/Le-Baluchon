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

    let numberOfLocation = 5
    var city = ""

    private var locationUrl: URL {
        return URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(city)&limit=\(numberOfLocation)&appid=\(weatherAPIKey)")!
    }

    private var session = URLSession(configuration: .default)
    private var task: URLSessionDataTask?

    func getLocation(callback: @escaping (Bool, [City]?) -> Void) {
        task?.cancel()
        task = session.dataTask(with: locationUrl) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
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
                print(data)
                print(response)
                print(responseJSON)
                callback(true, responseJSON)
            }
        }
        task?.resume()
    }

}
