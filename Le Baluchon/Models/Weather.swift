//
//  Weather.swift
//  Le Baluchon
//
//  Created by Maxime Point on 20/11/2022.
//

import Foundation

struct Weather: Decodable {
    
    // MARK: Data retrieved from the network call
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
    /// Url base to get the weather icon
    static var iconUrlBase = "https://openweathermap.org/img/wn/%@@2x.png"
    
    /// Returns the main weather description as a String type. If this description does't exist, it returns "-".
    var mainWeatherDescription: String {
        if self.weather.count > 0, let weatherDescription = self.weather[0].description {
            return weatherDescription
        } else {
            return "-"
        }
    }
    
    /// Returns the main weather icon as a optional String type. If this icon does't exist, it returns nil.
    var mainWeatherIcon: String? {
        if self.weather.count > 0, let weatherIcon = self.weather[0].icon {
            return weatherIcon
        } else {
            return nil
        }
    }
    
    
    /// Returns the temperature with the user's preferred unit.
    /// The returned temperature contains 1 decimal, and is of type string.
    var tempWithPreferredUnit: String? {
        guard let temp = self.main?.temp else { return nil }
        // Temperature unit in "temp" variable is Kelvin by default
        switch UserSettings.temperatureUnit {
            case .Celsius: return String(format: "%.1f", Float((temp) - 273.15))
            case .Fahrenheit: return String(format: "%.1f", Float((temp - 273.15) * (9/5) + 32))
            case .Kelvin: return String(format: "%.1f", Float(temp))
        }
    }
    
    /// Returns the temperature with its unit according to the user's preference.
    var tempLabel: String {
        guard let tempWithPreferredUnit = self.tempWithPreferredUnit else {
            return "-\(UserSettings.temperatureUnit.unit)"
        }
        return tempWithPreferredUnit + UserSettings.temperatureUnit.unit
    }
    
    /// Returns the date in the correct format according to the user language.
    var localDate: String {
        if let timeZone = self.timezone {
            return DateFormater.getDate(timeZone: timeZone)
        } else {
            return "-"
        }
    }
    
    
}
