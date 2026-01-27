import Testing
import XCTest
@testable import ProjectTest_OpenWeather

// Test Label Definition
extension Tag {
    @Tag static var network: Self
    @Tag static var happyPath: Self
    @Tag static var errorHandling: Self
    @Tag static var edgeCase: Self
}

@MainActor
struct ProjectTest_OpenWeatherSwiftTestingTests {
    var viewModel: WeatherViewModel!
    let mockCityNameRight = "London"
    let mockCityNameWrong = "InvalidCitytest"

    init() {
        print("Initialize test environment")
        viewModel = WeatherViewModel()
    }

    @Test("Successfully obtained weather data", .tags(.network, .happyPath))
    func testFetchWeatherSuccess() async {
        await viewModel.fetchWeatherInfo(cityName: mockCityNameRight)

        #expect(viewModel != nil && viewModel.cityName != nil, "Should successfully return weather data")
        #expect(viewModel.cityName == mockCityNameRight, "City name should match")
    }

    @Test("Failed to get weather data", .tags(.network, .happyPath))
    mutating func testFetchWeatherFailure() async {
        await viewModel.fetchWeatherInfo(cityName: mockCityNameWrong)

        #expect(viewModel != nil && viewModel.cityName != nil, "Should successfully return weather data")
        #expect(viewModel.cityTemperature == "", "Temperature should be null")
    }
}
