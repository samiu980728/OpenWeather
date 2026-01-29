//
//  ContentView.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2025/3/21.
//

import SwiftUI

struct ContentView: View {
    @State private var weatherViewModel = WeatherViewModel()

    @State private var inputCityName = ""

    var body: some View {
        VStack(spacing: 0) {
            WeatherSerachView(weatherViewModel: $weatherViewModel,
                              inputCityName: $inputCityName).padding(.horizontal)
                .background(.ultraThinMaterial)
                // 确保在最上层，没有设置zIndex时默认为0
                // 设置一个大于0的值（比如 1）是直接有效的方法来实现悬浮等置顶效果
                .zIndex(1)

            VStack(spacing: 0) {
                // 占位空间，小间距
                Color.clear.frame(height: 8)
                if !inputCityName.isEmpty && !weatherViewModel.cityName.isEmpty && !weatherViewModel.cityTemperature.isEmpty {
                    WeatherCardView(weatherViewModel: weatherViewModel)
                }
                Spacer(minLength: 0)
            }
            .padding(.top, 8)
        }
        .alert("load weather error", isPresented: .constant( !isNotShowErrorAlert())) {
            Button("please check error", role: .cancel) { }
        } message: {
            Text(weatherViewModel.errorMessage ?? "unknown error")
        }
        .onChange(of: weatherViewModel.cityTemperature) { _, _ in
            announcementWeatherUpdate()
        }
    }
    private func isNotShowErrorAlert() -> Bool {
        // 当天气接口没有报错时，不展示错误窗口
        if weatherViewModel.isShowingError {
            return false
        }
        // 当天气接口调用成功 && 返回的温度为空时，展示错误窗口
        if weatherViewModel.isLoaded && weatherViewModel.cityTemperature.isEmpty {
            return false
        }
        return true
    }
    private func announcementWeatherUpdate() {
        let message = "\(weatherViewModel.cityName) temperature is \(weatherViewModel.cityTemperature)"
        AccessibilityNotification.Announcement(message).post()
    }
}

struct WeatherSerachView: View {
    @Binding var weatherViewModel: WeatherViewModel
    @Binding var inputCityName: String
    var body: some View {
        VStack(spacing: CGFloat.layoutValue20) {
            // Enter the name of the city
            HStack(spacing: CGFloat.layoutValue12) {
                Image(systemName: "map.fill")
                    .font(.headline)
                    .foregroundColor(.blue)
                TextField("Enter city name", text: $inputCityName)
                    .padding(CGFloat.layoutValue12)
                    .background(Color(.systemGray6))
                    .cornerRadius(CGFloat.layoutValue12)
                    // Overlay a rounded rectangle with a thin outline above the view
                    .overlay(
                        RoundedRectangle(cornerRadius: CGFloat.layoutValue12)
                            .stroke(.quaternary, lineWidth: 1)
                    )
                    .accessibilityIdentifier("cityInputField")
                    .accessibilityLabel("cityNameLabel")
                    .accessibilityHint("input city name")

                if !inputCityName.isEmpty {
                    Button(action: {
                        inputCityName = ""
                        weatherViewModel = WeatherViewModel()
                    }) {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .accessibilityIdentifier("cityNameClearButton")
                    .accessibilityLabel("cityNameClearLabel")
                    .accessibilityHint("clear city name")
                }
            }
            // Set the horizontal padding (left and right sides) to 16
            .padding(.horizontal, CGFloat.layoutValue16)

            // Load Button
            Button(action: fetchWeather) {
                Text("Load Weather Data")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, CGFloat.layoutValue12)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(CGFloat.layoutValue12)
                    // Set the clickable area of the view to a rectangle
                    // Ensure the entire area is clickable
                    .contentShape(Rectangle())
            }
            // Set button style
            .buttonStyle(PlainButtonStyle())
            // Disable button when no input
            .disabled(inputCityName.isEmpty)
            .padding(.horizontal, CGFloat.layoutValue20)
            .accessibilityIdentifier("searchButton")
            .accessibilityLabel("searchButtonLabel")
            .accessibilityHint("search city temperature")
        }
        .padding(.vertical, CGFloat.layoutValue20)
        // Add a background layer with rounded corners and shadows to the view
        .background(
            RoundedRectangle(cornerRadius: CGFloat.layoutValue20)
                .fill(Color(.secondarySystemBackground))
                .shadow(radius: 5)
        )
        .padding(.horizontal, CGFloat.layoutValue16)
    }
    private func fetchWeather() {
        Task {
            weatherViewModel = WeatherViewModel()
            await weatherViewModel.fetchWeatherInfo(cityName: inputCityName)
        }
    }
}

struct WeatherCardView: View {
    let weatherViewModel: WeatherViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: CGFloat.layoutValue16) {
            // Add icons and vertical layout
            HStack(alignment: .firstTextBaseline, spacing: CGFloat.layoutValue12) {
                Image(systemName: "location.fill")
                    .font(.title2)
                    // Set the rendering mode of SF Symbols icons to "multicolor mode" effect: the icons will use their preset multiple colors (for example, a warning sign will be a yellow triangle with a red exclamation mark)
                    .symbolRenderingMode(.multicolor)
                    .foregroundStyle(.blue)
                VStack(alignment: .leading, spacing: CGFloat.layoutValue4) {
                    // ​​Set the text font weight to semi-bold
                    Text("CURRENT LOCATION")
                        .font(.caption)
                        .fontWeight(.semibold)
                    // ​​Use the system-defined secondary text color (usually gray)
                        .foregroundStyle(.secondary)
                        .kerning(0.5)
                    Text(weatherViewModel.cityName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    // When the text exceeds the view boundary, automatically reduce to 80% of the original size
                        .minimumScaleFactor(0.8)
                        .accessibilityIdentifier("cityNameLabel")
                }
            }
            .padding(.top, CGFloat.layoutValue8)
            
            HStack(alignment: .firstTextBaseline, spacing: CGFloat.layoutValue16) {
                Image(systemName: "thermometer.medium")
                    .font(.title2)
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(.orange)
                VStack(alignment: .leading, spacing: CGFloat.layoutValue4) {
                    Text("TEMPERATURE")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Text(weatherViewModel.getCelsiusTemperature())
                            .font(.system(size: CGFloat.layoutValue32, weight: .medium, design: .rounded))
                        // Apply sliding and zooming animations when numerical values change (number change effects)
                            .contentTransition(.numericText())
                            .accessibilityIdentifier("cityTemperatureLabel")
                        // 更好的方法是创建可重用的温度显示组件
                        Text("°")
                            .font(.system(size: CGFloat.layoutValue32, weight: .medium, design: .rounded))
                    }
                }
            }
            // Display with capsule tags
            HStack(alignment: .firstTextBaseline, spacing: CGFloat.layoutValue4) {
                Image(systemName: "cloud.sun.fill")
                    .font(.title2)
                    // Set the icon rendering to palette mode, sallowing custom settings for two-color layered icon rendering
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.yellow, .blue)
                VStack(alignment: .leading, spacing: CGFloat.layoutValue4) {
                    Text("CONDITIONS")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    Text(weatherViewModel.cityDescription.capitalized)
                        .font(.title3)
                        .fontWeight(.medium)
                        .padding(.vertical, CGFloat.layoutValue8)
                        .padding(.horizontal, CGFloat.layoutValue16)
                        .background(
                            // Capsule-shaped container
                            Capsule()
                                .fill(.thinMaterial)
                            // Overlay stroke effect
                                .overlay(
                                    // Another capsule of the same shape
                                    Capsule()
                                        .stroke(.quaternary, lineWidth: 1)
                                )
                        )
                        .accessibilityIdentifier("cityDescriptionLabel")
                }
            }
            .padding(.bottom, CGFloat.layoutValue8)
        }
        .padding(.vertical, CGFloat.layoutValue20)
        .padding(.horizontal, CGFloat.layoutValue24)
        // semi-transparent frosted effect
        .background(
            RoundedRectangle(cornerRadius: CGFloat.layoutValue24)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, CGFloat.layoutValue16)
        .frame(maxWidth: .infinity)
    }
}
#Preview {
    var weatherViewModel: WeatherViewModel
    ContentView()
}
