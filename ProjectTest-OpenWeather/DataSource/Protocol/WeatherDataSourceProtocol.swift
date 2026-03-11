//
//  WeatherDataSourceProtocol.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2026/3/11.
//

protocol WeatherDataSource {
    func fetchWeather(cityName: String) async throws -> WeatherResponseModel?
}
