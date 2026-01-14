import Testing
import XCTest
@testable import ProjectTest_OpenWeather


// MARK: - 测试标签定义
extension Tag {
    @Tag static var network: Self
    @Tag static var happyPath: Self
    @Tag static var errorHandling: Self
    @Tag static var edgeCase: Self
}

@MainActor  // 确保整个测试套件在主线程运行
struct ProjectTest_OpenWeatherSwiftTestingTests {
    
    // SwiftTesting里无法使用XCUIApplication
//    var app: XCUIApplication!
    var viewModel: WeatherViewModel!
    
    let mockCityNameRight = "London"
    let mockCityNameWrong = "InvalidCitytest"

    init() {
        print("初始化测试环境")
        viewModel = WeatherViewModel()
    }
    
    @Test("成功获取天气数据", .tags(.network, .happyPath))
    func testFetchWeatherSuccess() async {
        await viewModel.fetchWeatherInfo(cityName: mockCityNameRight)
        
        // 验证结果
        #expect(viewModel != nil && viewModel.cityName != nil, "应该成功返回天气数据")
        #expect(viewModel.cityName == mockCityNameRight, "城市名称应该匹配")
    }
    
    @Test("获取天气数据失败", .tags(.network, .happyPath))
    mutating func testFetchWeatherFailure() async {
        await viewModel.fetchWeatherInfo(cityName: mockCityNameWrong)
        
        // 验证结果
        #expect(viewModel != nil && viewModel.cityName != nil, "应该成功返回天气数据")
        #expect(viewModel.cityTemperature == "", "温度应该为空值")
    }
}
