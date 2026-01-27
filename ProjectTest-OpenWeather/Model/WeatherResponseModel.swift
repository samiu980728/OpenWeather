//
//  WeatherResponseModel.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2025/3/21.
//

import Foundation

// API：https://openweathermap.org/current
struct WeatherResponseModel: Codable {
    var timezone: Int
    var weather: [WeatherModel]
    var main: MainModel
    var name: String
}
