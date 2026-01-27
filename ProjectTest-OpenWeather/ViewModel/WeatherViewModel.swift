import Foundation

@Observable
final class WeatherViewModel: ObservableObject {
     var cityName: String = ""
     var cityDescription: String = ""
     var cityTemperature: String = ""
     var errorMessage: String?
     var isLoading = false
     var isShowingError = false

    private let repository: WeatherRepository

    init(repository: WeatherRepository = DefaultWeatherRepository()) {
        self.repository = repository
    }

    func fetchWeatherInfo(cityName: String) async {
        self.isLoading = true
        self.isShowingError = false
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
