//
//  WeatherDataSource.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2025/6/11.
//

import Foundation

protocol WeatherDataSource {
    func fetchWeather(cityName: String) async throws -> WeatherResponseModel?
}

enum WeatherRequestError: Error {
    case noInternetConnection
    case requestTimedOut
    case invalidURL
    case serverError(statusCode: Int)
    case parsingError(description: String)
    case unknownError
}

struct NetworkWeatherDataSource: WeatherDataSource {
    private let weatherRequestBaseUrl = "https://api.openweathermap.org/data/2.5/weather?"
    private let geocodingRequestBaseUrl = "https://api.openweathermap.org/geo/1.0/direct?"
    private let geocodingRequestLimit = 5
    private let geocodingRequestApiKey = "bc3738a74cfe2a2ba18c14243d36f6d3"
    func fetchWeather(cityName: String) async throws -> WeatherResponseModel? {
        let geocodingModelArray = try await getWeatherModel(cityName: cityName)
        if !geocodingModelArray.isEmpty {
            let weatherGeocodingModel = geocodingModelArray[0]
            // finalWeatherRequestUrl    String    "https://api.openweathermap.org/data/3.0/onecall?lat=51.5073219&lon=-0.1276474&appid=bc3738a74cfe2a2ba18c14243d36f6d3"
            let finalWeatherRequestUrl = "\(weatherRequestBaseUrl)lat=\(weatherGeocodingModel.lat)&lon=\(weatherGeocodingModel.lon)&appid=\(geocodingRequestApiKey)"
            guard let requestUrl = URL(string: finalWeatherRequestUrl) else {
                throw WeatherRequestError.invalidURL
            }
            let (data, _) = try await URLSession.shared.data(from: requestUrl)
            if let jsonString = String(data: data, encoding: .utf8) {
                Logger.debug("Original JSON data: \(jsonString)")
            }
            let responseModel = try JSONDecoder().decode(WeatherResponseModel.self, from: data)
            return responseModel
        }
        return nil
    }

    private func getWeatherModel(cityName: String) async throws -> [WeatherGeocodingModel] {
        let finalGeocodingRequestUrl = "\(geocodingRequestBaseUrl)q=\(cityName)&limit=\(geocodingRequestLimit)&appid=\(geocodingRequestApiKey)"
        guard let requestUrl = URL(string: finalGeocodingRequestUrl) else {
            throw WeatherRequestError.invalidURL
        }

            let (data, _) = try await URLSession.shared.data(from: requestUrl)
            #if DEBUG
            if let jsonString = String(data: data, encoding: .utf8) {
                Logger.debug("Original JSON data: \(jsonString)")
            }
            #endif
            let geocodingModel = try JSONDecoder().decode([WeatherGeocodingModel].self, from: data)
            return geocodingModel
    }
}
