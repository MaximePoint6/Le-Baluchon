//
//  Weather.swift
//  Le Baluchon
//
//  Created by Maxime Point on 20/11/2022.
//

import Foundation

struct Weather: Decodable {
    
    var coord: Coord?
    var weather: [WeatherDescription]
    var base: String?
    var main: Main?
    var visibility: Int?
    var wind: Wind?
    var clouds: Clouds?
    var dt: Int?
    var sys: Sys?
    var timezone: Int?
    var id: Int?
    var name: String?
    var cod: Int?
    
    struct Coord: Decodable {
        var lon: Double?
        var lat: Double?
    }
    
    struct WeatherDescription: Decodable {
        var id: Int?
        var main: String?
        var description: String?
        var icon: String?
    }
    
    struct Main: Decodable {
        var temp: Double?
        var feelsLike: Double?
        var tempMin: Double?
        var tempMax: Double?
        var pressure: Int?
        var humidity: Int?
        var seaLevel: Int?
        var grndLevel: Int?
        
        var tempPreference: Float? {
            // temperature unit is Kelvin by default
            guard let temp = self.temp else {
                return nil
            }
            switch UserSettings.shared.temperatureUnit {
            case .Celsius: return Float((temp) - 273.15)
            case .Fahrenheit: return Float((temp - 273.15) * (9/5) + 32)
            case .Kelvin: return Float(temp)
            }
        }
    }
    
    struct Wind: Decodable {
        var speed: Double?
        var deg: Int?
        var gust: Double?
    }
    
    struct Clouds: Decodable {
        var all: Int?
    }
    
    struct Sys: Decodable {
        var type: Int?
        var id: Int?
        var country: String?
        var sunrise: Int?
        var sunset: Int?
    }
}
