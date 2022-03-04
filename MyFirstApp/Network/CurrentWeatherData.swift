//
//  CurrentWeatherData.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 3/2/22.
//

import Foundation


// MARK: - модель для заполнения полученными данными

struct CurrentWeatherData: Codable {
    
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    
    // MARK: - Для изменения названий ключей создаем enum и подписываемся под стринг и СodingKeys
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }
}

struct Weather: Codable {
    let id: Int
    let weatherDescription: String

    enum CodingKeys: String, CodingKey {
        case id
        case weatherDescription = "description"
    }
}

