//
//  CurrentWeatherModel.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2025/3/28.
//

import Foundation

struct WeatherModel: Codable {
    let id: Int
    let cityDescription: String

    enum CodingKeys: String, CodingKey {
        case id
        case cityDescription = "description"
    }
}

struct MainModel: Codable {
    let temperature: Float
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
    }
}
