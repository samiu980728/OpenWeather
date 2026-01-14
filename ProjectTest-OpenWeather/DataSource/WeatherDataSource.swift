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

    // 这里传的时候传fetchWeatherWithRequestModel(geocodingModelArray[0]
    // 就可以！然后这个fetchWeather方法就直接用这个第0个元素！
    
    // 该方法：请求url拼接时需要进行一次网络请求，这一次网络请求是在getWeatherModel方法里进行的，然后这个方法会返回一个数组，我们实际只用这个数组里的第一个元素。至于是为什么？可以打断点看看这个数组的数据结构先
    // 然后在fetchWeather这个方法里，传入刚才网络请求里请求到的第一个元素model，
    // 然后用这个model里的经度和维度来构建【最终的网络请求url】，然后发起请求
    func fetchWeather(cityName: String) async throws -> WeatherResponseModel? {
        let geocodingModelArray = try await getWeatherModel(cityName: cityName)
        if !geocodingModelArray.isEmpty {
            let weatherGeocodingModel = geocodingModelArray[0]
            // finalWeatherRequestUrl    String    "https://api.openweathermap.org/data/3.0/onecall?lat=51.5073219&lon=-0.1276474&appid=bc3738a74cfe2a2ba18c14243d36f6d3"
            let finalWeatherRequestUrl = "\(weatherRequestBaseUrl)lat=\(weatherGeocodingModel.lat)&lon=\(weatherGeocodingModel.lon)&appid=\(geocodingRequestApiKey)"
            guard let requestUrl = URL(string: finalWeatherRequestUrl) else {
                throw WeatherRequestError.invalidURL
            }
            /* 这里的 do-catch 没有意义 */
            // 这里直接注释，因为是系统错误，上面的throws关键字会跑错误的
            let (data, _) = try await URLSession.shared.data(from: requestUrl)
            if let jsonString = String(data: data, encoding: .utf8) {
                Logger.debug("原始 JSON 数据: \(jsonString)")
            }
            let responseModel = try JSONDecoder().decode(WeatherResponseModel.self, from: data)
            return responseModel
        }
        return nil
    }
    
    // 这里拿到的是数组 但实际只用数组里的第一个元素
    private func getWeatherModel(cityName: String) async throws -> [WeatherGeocodingModel] {
        let finalGeocodingRequestUrl = "\(geocodingRequestBaseUrl)q=\(cityName)&limit=\(geocodingRequestLimit)&appid=\(geocodingRequestApiKey)"
        guard let requestUrl = URL(string: finalGeocodingRequestUrl) else {
            throw WeatherRequestError.invalidURL
        }
        /* 这里的 do-catch 没有意义 */
//        do {
            let (data, _) = try await URLSession.shared.data(from: requestUrl)
            /* 作为调试用的代码在成品时要删掉， 或者用 #if DEBUG 宏 */
            if let jsonString = String(data: data, encoding: .utf8) {
                Logger.debug("原始 JSON 数据: \(jsonString)")
            }
            let geocodingModel = try JSONDecoder().decode([WeatherGeocodingModel].self, from: data)
            return geocodingModel
//        } catch {
//            Logger.error("decode geocodingData error：\(error.localizedDescription)")
//            throw error
//        }
    }
}
