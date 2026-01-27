//
//  WeatherRepository.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2025/6/11.
//

import Foundation

protocol WeatherRepository {
    func getWeatherResponseModel(cityName: String) async throws -> WeatherResponseModel?
}

struct DefaultWeatherRepository: WeatherRepository {
    private let dataSource: WeatherDataSource

    private let weatherRequestBaseUrl = "https://api.openweathermap.org/data/2.5/weather?"

    private let geocodingRequestBaseUrl = "https://api.openweathermap.org/geo/1.0/direct?"
    private let geocodingRequestLimit = 5
    private let geocodingRequestApiKey = "bc3738a74cfe2a2ba18c14243d36f6d3"

    init(dataSource: WeatherDataSource = NetworkWeatherDataSource()) {
        self.dataSource = dataSource
    }

    func getWeatherResponseModel(cityName: String) async throws -> WeatherResponseModel? {
        try await dataSource.fetchWeather(cityName: cityName) ?? nil
    }
}
