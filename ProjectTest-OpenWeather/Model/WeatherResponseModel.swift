//
//  WeatherResponseModel.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2025/3/21.
//

import Foundation

// API：https://openweathermap.org/current
struct WeatherResponseModel: Codable {
    let timezone: Int
    let weather: [WeatherModel]
    let main: MainModel
    let name: String
}
