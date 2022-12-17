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
    
    
    // MARK: Tools for ViewControllers
    /// Returns the main weather description as a String type. If this description does't exist, it returns "-".
    var mainWeatherDescription: String {
        if self.weather.count > 0 {
            if let weatherDescription = self.weather[0].description {
                return weatherDescription
            }
        }
        return "-"
    }
    
    /// Returns the main weather icon as a optional String type. If this icon does't exist, it returns nil.
    var mainWeatherIcon: String? {
        if self.weather.count > 0 {
            if let weatherIcon = self.weather[0].icon {
                return weatherIcon
            }
        }
        return nil
    }
    
    
    /// Returns the temperature with the user's preferred unit.
    /// The returned temperature contains 1 decimal, and is of type string.
    var tempWithPreferredUnit: String? {
        guard let temp = self.main?.temp else { return nil }
        // Temperature unit in "temp" variable is Kelvin by default
        switch UserSettings.shared.temperatureUnit {
            case .Celsius: return String(format: "%.1f", Float((temp) - 273.15))
            case .Fahrenheit: return String(format: "%.1f", Float((temp - 273.15) * (9/5) + 32))
            case .Kelvin: return String(format: "%.1f", Float(temp))
        }
    }
    
    var tempLabel: String {
        guard let tempWithPreferredUnit = self.tempWithPreferredUnit else {
            return "-\(UserSettings.shared.temperatureUnit.unit)"
        }
        // Temperature unit in "temp" variable is Kelvin by default
        return "\(tempWithPreferredUnit)\(UserSettings.shared.temperatureUnit.unit)"
    }
    
    var localDate: String {
        if let timeZone = self.timezone {
            return DateFormater.getDate(timeZone: timeZone)
        } else {
            return "-"
        }
    }

    
}
