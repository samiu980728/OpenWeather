//
//  WeatherViewModelTests.swift
//  ProjectTest-OpenWeatherTests
//
//  Created by 景鹏旭 on 2025/6/23.
//

import XCTest
@testable import ProjectTest_OpenWeather

@MainActor
final class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var mockRepository: MockWeatherRepository!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        mockRepository = MockWeatherRepository()
        viewModel = WeatherViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchWeatherSuccess() async {
        let expectedWeather = WeatherResponseModel(timezone: 9999, weather: .init(), main: .init(temperature: 9999), name: "test")
        mockRepository.mockResult = .success(expectedWeather)

        await viewModel.fetchWeatherInfo(cityName: "London")

        XCTAssertEqual(viewModel.cityName, "London")
        XCTAssertNotEqual(viewModel.cityTemperature, "")
    }

    func testFetchWeatherFailure() async {
        mockRepository.mockResult = .failure(.unknownError)

        await viewModel.fetchWeatherInfo(cityName: "ErrorCity")

        XCTAssertEqual(viewModel.cityName, "ErrorCity")
        XCTAssertEqual(viewModel.cityTemperature, "")
    }

    func testPerformanceFetchWeather() {
        measure {
            let exp = expectation(description: "Fetch weather")

            Task {
                await viewModel.fetchWeatherInfo(cityName: "London")
                exp.fulfill()
            }

            wait(for: [exp], timeout: 2.0)
        }
    }
}

class MockWeatherRepository: WeatherRepository {
    var mockResult: Result<WeatherResponseModel, WeatherRequestError> = .failure(.unknownError)

    func getWeatherResponseModel(cityName: String) async throws -> ProjectTest_OpenWeather.WeatherResponseModel? {
        switch mockResult {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
}
