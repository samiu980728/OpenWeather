//
//  WeatherGeocodingRequestModel.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2025/3/21.
//

import Foundation

struct WeatherGeocodingModel: Codable {
    var name: String
    var lat: Double
    var lon: Double
    var country: String
    var state: String
}
