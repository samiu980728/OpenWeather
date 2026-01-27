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

    // Normal process test
    func testSuccessfulWeatherFetch() {
        let cityField = app.textFields["cityInputField"]
        cityField.doubleTap()
        // Wait one second to ensure the text field is interactive
        XCTAssertTrue(cityField.waitForExistence(timeout: 1))
        cityField.typeText("London")
        app.buttons["searchButton"].tap()

        let cityLabel = app.staticTexts["cityNameLabel"]
        XCTAssertTrue(cityLabel.waitForExistence(timeout: 10))
        XCTAssertEqual(cityLabel.label, "London")
    }

    // Invalid process test
    func testInvalidCityError() {
        let cityField = app.textFields["cityInputField"]
        cityField.doubleTap()
        // Wait one second to ensure the text field is interactive
        XCTAssertTrue(cityField.waitForExistence(timeout: 1))
        cityField.typeText("InvalidCitytest")

        app.buttons["searchButton"].tap()

        let cityTemperatureLabel = app.staticTexts["cityTemperatureLabel"]
        let exists = cityTemperatureLabel.waitForExistence(timeout: 5)
        if exists {
            // Get label text
            let labelText = cityTemperatureLabel.label
            if labelText.isEmpty || labelText.count == 0 {
                print("✅ Text is empty, test passed")
            } else {
                XCTFail("❌ Text is not empty：'\(labelText)', Test failed")
            }
        } else {
            // Considered passed if the element does not exist
            print("✅ [\(cityTemperatureLabel.identifier)] Element does not exis, test passed")
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
