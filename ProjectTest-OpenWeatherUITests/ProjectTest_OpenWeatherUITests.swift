//
//  ProjectTest_OpenWeatherUITests.swift
//  ProjectTest-OpenWeatherUITests
//
//  Created by 景鹏旭 on 2025/3/21.
//

import XCTest

final class ProjectTest_OpenWeatherUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        app.launchArguments = ["-UITesting"]
        app.launch()
    }
    
    // MARK: - 正常流程测试
    func testSuccessfulWeatherFetch() {
        // 输入城市
        let cityField = app.textFields["cityInputField"]
        cityField.doubleTap()
        // 等待一秒，确保文本字段可交互
        XCTAssertTrue(cityField.waitForExistence(timeout: 1))
        cityField.typeText("London")
        
        // 点击查询按钮
        app.buttons["searchButton"].tap()
        
        // 验证结果
        let cityLabel = app.staticTexts["cityNameLabel"]
        XCTAssertTrue(cityLabel.waitForExistence(timeout: 10))
        XCTAssertEqual(cityLabel.label, "London")
    }
    
    // MARK: - 错误处理测试
    func testInvalidCityError() {
        // 输入无效城市
        let cityField = app.textFields["cityInputField"]
        cityField.doubleTap()
        // 等待一秒，确保文本字段可交互
        XCTAssertTrue(cityField.waitForExistence(timeout: 1))
        cityField.typeText("InvalidCitytest")
        
        // 点击查询按钮
        app.buttons["searchButton"].tap()
        
        // 验证错误提示
        let cityTemperatureLabel = app.staticTexts["cityTemperatureLabel"]
        let exists = cityTemperatureLabel.waitForExistence(timeout: 5)
        if exists {
            // 获取标签文本
            let labelText = cityTemperatureLabel.label
            // 判断文本是否为空
            if labelText.isEmpty || labelText.count == 0 {
                // 文本为空 → 测试通过
                print("✅ 温度标签存在且文本为空")
            } else {
                // 文本不为空 → 测试失败
                XCTFail("❌ 温度标签文本不为空：'\(labelText)'")
            }
        } else {
            // 元素不存在时自动通过
            print("✅ [\(cityTemperatureLabel.identifier)] 元素不存在（等效文本为空）")
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
