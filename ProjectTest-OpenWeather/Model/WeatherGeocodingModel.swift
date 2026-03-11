//
//  WeatherGeocodingRequestModel.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2025/3/21.
//

import Foundation

struct WeatherGeocodingModel: Codable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String
}
