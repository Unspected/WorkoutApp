//
//  NetworkRequest.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 2/25/22.
//

import Foundation
import CoreLocation

class NetworkWeatherManager {
    
    private let apiKey = "9b1c307390474827d825e64b349267f1"

    func fetchCurrentWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees, complitionHandler: @escaping (CurrentWeather) -> Void) {

        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longtitude)&apikey=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = self.parseJSON(withData: data) {
                    print(currentWeather)
                    complitionHandler(currentWeather)
                }
            }
        }
        task.resume()
    }

    fileprivate func parseJSON(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else { return nil }
            
            return currentWeather
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        return nil
    }

}


