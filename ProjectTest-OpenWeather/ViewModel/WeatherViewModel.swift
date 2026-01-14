////
////  WeatherViewModel.swift
////  ProjectTest-OpenWeather
////
////  Created by 景鹏旭 on 2025/6/11.
////
//
//import Foundation
//
//// 问题：这里用MainActor的话可以吗？如果不用的话会有这个报错：SwiftUI 要求所有 UI 更新必须在主线程上进行
//@MainActor
//final class WeatherViewModel: ObservableObject {
//    @Published var cityName: String = ""
//    @Published var cityDescription: String = ""
//    @Published var cityTemperature: String = ""
//    @Published var errorMessage: String?
//    @Published var isLoading = false
//    @Published var isShowingError = false
//
//    private let repository: WeatherRepository
//
//    // TODO 为什么要这样写？DefaultWeatherRepository()
//    init(repository: WeatherRepository = DefaultWeatherRepository()) {
//        self.repository = repository
//    }
//
//    // 问题：updateUI后怎么和UI相关联？看这个：                          Text(viewModel.tempRange)
//    func fetchWeatherInfo(cityName: String) async {
//        self.isLoading = true
//        self.isShowingError = false;
//        self.errorMessage = nil
//        self.cityName = cityName
//
//        do {
//            let weatherData = try await repository.getWeatherResponseModel(cityName: cityName)
//            if let warpWeatherData = weatherData {
//                updateUI(warpWeatherData)
//            }
//        } catch {
//            handleError(error)
//        }
//        isLoading = false
//    }
//
//    private func handleError(_ error: Error) {
//        isShowingError = true
//        if let weatherError = error as? WeatherRequestError {
//            switch weatherError {
//                case .invalidURL:
//                /* 尝试用OSLog写一个Logger， 用Logger打印调试信息， 避免使用print() */
//                Logger.error("invaild url error")
//                    errorMessage = "invaild url error"
//                default:
//                    errorMessage = "未知错误"
//            }
//        } else {
//            errorMessage = error.localizedDescription
//        }
//    }
//
//    private func updateUI(_ weatherResponseModel: WeatherResponseModel) {
//        // 问题：这里是否可以优化？
//        cityTemperature = String(weatherResponseModel.main.temperature)
//        guard let weather = weatherResponseModel.weather.first else {
//            return
//        }
//        // 这句代码是否要优化？
//        cityDescription = weather.cityDescription
//    }
//}


//
//  WeatherViewModel.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2025/6/11.
//

import Foundation

// 问题：这里用MainActor的话可以吗？如果不用的话会有这个报错：SwiftUI 要求所有 UI 更新必须在主线程上进行
// 使用@Observable，上面的注释里是旧版的实现
@Observable
final class WeatherViewModel: ObservableObject {
     var cityName: String = ""
     var cityDescription: String = ""
     var cityTemperature: String = ""
     var errorMessage: String?
     var isLoading = false
     var isShowingError = false
    
    private let repository: WeatherRepository

    // TODO 为什么要这样写？DefaultWeatherRepository()
    init(repository: WeatherRepository = DefaultWeatherRepository()) {
        self.repository = repository
    }
    
    // 问题：updateUI后怎么和UI相关联？看这个：                          Text(viewModel.tempRange)
//    @MainActor
    func fetchWeatherInfo(cityName: String) async {
        self.isLoading = true
        self.isShowingError = false;
        self.errorMessage = nil
        self.cityName = cityName
        
        do {
            let weatherData = try await repository.getWeatherResponseModel(cityName: cityName)
            if let warpWeatherData = weatherData {
                updateUI(warpWeatherData)
            }
        } catch {
            handleError(error)
        }
        isLoading = false
    }
    
//    @MainActor
    private func handleError(_ error: Error) {
        isShowingError = true
        if let weatherError = error as? WeatherRequestError {
            switch weatherError {
                case .invalidURL:
                /* 尝试用OSLog写一个Logger， 用Logger打印调试信息， 避免使用print() */
                Logger.error("invaild url error")
                    errorMessage = "invaild url error"
                default:
                    errorMessage = "未知错误"
            }
        } else {
            errorMessage = error.localizedDescription
        }
    }
    
//    @MainActor
    private func updateUI(_ weatherResponseModel: WeatherResponseModel) {
        // 问题：这里是否可以优化？
        cityTemperature = String(weatherResponseModel.main.temperature)
        guard let weather = weatherResponseModel.weather.first else {
            return
        }
        // 这句代码是否要优化？
        cityDescription = weather.cityDescription
    }
}
