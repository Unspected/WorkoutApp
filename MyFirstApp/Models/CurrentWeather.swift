//
//  CurrentWeather.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 3/2/22.
//
import Foundation

// FINAL MODEL
struct CurrentWeather {
    let cityName: String
    
    let temperature: Double
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    let feelsLikeTemperature: Double
    var feelsLikeTemperatureString: String {
        return String(format: "%.0f", feelsLikeTemperature)
    }
    
    var weatherDescription: String
    
    let conditionCode: Int
    var systemIconNameString: String {
        switch conditionCode {
        case 200...232: return "thunder"
        case 300...321: return "drizzle"
        case 500...531: return "rain"
        case 600...621: return "snow"
        case 700...781: return "smoke"
        case 800: return "sun"
        case 801...804: return "clouds"
        default:
            return "nosign"
            
        }
    }
    
    init?(currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLikeTemperature = currentWeatherData.main.feelsLike
        conditionCode = currentWeatherData.weather.first!.id
        weatherDescription = currentWeatherData.weather.first!.weatherDescription
    }
}

