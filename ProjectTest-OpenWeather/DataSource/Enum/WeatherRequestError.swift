//
//  WeatherRequestError.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2026/3/11.
//

import Foundation

enum WeatherRequestError: Error {
    case noInternetConnection
    case requestTimedOut
    case invalidURL
    case serverError(statusCode: Int)
    case parsingError(description: String)
    case unknownError
}
