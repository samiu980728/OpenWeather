import Foundation

@Observable
final class WeatherViewModel {
     var cityName: String = ""
     var cityDescription: String = ""
     var cityTemperature: String = ""
     var errorMessage: String?
     var isLoaded = false
     var isShowingError = false

    private let repository: WeatherRepository

    init(repository: WeatherRepository = DefaultWeatherRepository()) {
        self.repository = repository
    }

    func fetchWeatherInfo(cityName: String) async {
        // Note that it is different from OC. It is not necessary to use "self".
        isShowingError = false
        errorMessage = nil
        self.cityName = cityName

        do {
            let weatherData = try await repository.getWeatherResponseModel(cityName: cityName)
            isLoaded = true
            if let weatherData {
                updateUI(weatherData)
            }
        } catch {
            handleError(error)
        }
    }

    private func handleError(_ error: Error) {
        isShowingError = true
        if let weatherError = error as? WeatherRequestError {
            switch weatherError {
            case .invalidURL:
            Logger.error("invaild url error")
                errorMessage = "invaild url error"
            default:
                errorMessage = "unknown error"
            }
        } else {
            errorMessage = error.localizedDescription
        }
    }

    private func updateUI(_ weatherResponseModel: WeatherResponseModel) {
        cityTemperature = String(weatherResponseModel.main.temperature)
        guard let weather = weatherResponseModel.weather.first else {
            return
        }
        cityDescription = weather.cityDescription
    }
}

extension WeatherViewModel {
    func getCelsiusTemperature() -> String {
        if cityTemperature.isEmpty {
            return cityTemperature
        }
        return String(Int((Double(cityTemperature) ?? 0) - 273.15))
    }
}
