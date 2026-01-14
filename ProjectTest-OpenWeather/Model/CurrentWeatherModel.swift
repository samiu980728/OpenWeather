//
//  CurrentWeatherModel.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2025/3/28.
//

import Foundation

struct WeatherModel: Codable {
    var id: Int
    var cityDescription: String

    enum CodingKeys: String, CodingKey {
        case id
        case cityDescription = "description"
    }
}

struct MainModel: Codable {
    var temperature: Float
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
    }
}
