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

    enum UILayoutValue: CGFloat {
        case layoutValue4 = 4.0
        case layoutValue8 = 8.0
        case layoutValue12 = 12.0
        case layoutValue16 = 16.0
        case layoutValue20 = 20.0
        case layoutValue24 = 24.0
        case layoutValue32 = 32.0
    }

    var body: some View {
        VStack {
            VStack(spacing: UILayoutValue.layoutValue20.rawValue) {
                // Enter the name of the city
                HStack(spacing: UILayoutValue.layoutValue12.rawValue) {
                    Image(systemName: "map.fill")
                        .font(.headline)
                        .foregroundColor(.blue)
                    TextField("Enter city name", text: $inputCityName)
                        .padding(UILayoutValue.layoutValue12.rawValue)
                        .background(Color(.systemGray6))
                        .cornerRadius(UILayoutValue.layoutValue12.rawValue)
                    // Overlay a rounded rectangle with a thin outline above the view
                        .overlay(
                            RoundedRectangle(cornerRadius: UILayoutValue.layoutValue12.rawValue)
                                .stroke(.quaternary, lineWidth: 1)
                        )
                        .accessibilityIdentifier("cityInputField")
                        .accessibilityLabel("cityNameLabel")
                        .accessibilityHint("input city name")

                    if !inputCityName.isEmpty {
                        Button(action: {
                            inputCityName = ""
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
                .padding(.horizontal, UILayoutValue.layoutValue16.rawValue)

                // Load Button
                Button(action: fetchWeather) {
                    Text("Load Weather Data")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, UILayoutValue.layoutValue12.rawValue)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(UILayoutValue.layoutValue12.rawValue)
                    // Set the clickable area of the view to a rectangle
                    // Ensure the entire area is clickable
                        .contentShape(Rectangle())
                }
                // Set button style
                .buttonStyle(PlainButtonStyle())
                // Disable button when no input
                .disabled(inputCityName.isEmpty)
                .padding(.horizontal, UILayoutValue.layoutValue20.rawValue)
                .accessibilityIdentifier("searchButton")
                .accessibilityLabel("searchButtonLabel")
                .accessibilityHint("search city temperature")
            }
            .padding(.vertical, UILayoutValue.layoutValue20.rawValue)
            // Add a background layer with rounded corners and shadows to the view
            .background(
                RoundedRectangle(cornerRadius: UILayoutValue.layoutValue20.rawValue)
                    .fill(Color(.secondarySystemBackground))
                    .shadow(radius: 5)
            )
            .padding(.horizontal, UILayoutValue.layoutValue16.rawValue)

            if !weatherViewModel.cityName.isEmpty && !weatherViewModel.cityTemperature.isEmpty {
                VStack(spacing: UILayoutValue.layoutValue16.rawValue) {
                    // Add icons and vertical layout
                    HStack(alignment: .firstTextBaseline, spacing: UILayoutValue.layoutValue12.rawValue) {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            // Set the rendering mode of SF Symbols icons to "multicolor mode" effect: the icons will use their preset multiple colors (for example, a warning sign will be a yellow triangle with a red exclamation mark)
                            .symbolRenderingMode(.multicolor)
                            .foregroundStyle(.blue)

                        VStack(alignment: .leading, spacing: UILayoutValue.layoutValue4.rawValue) {
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
                    .padding(.top, UILayoutValue.layoutValue8.rawValue)

                    HStack(alignment: .center, spacing: UILayoutValue.layoutValue16.rawValue) {
                        Image(systemName: "thermometer.medium")
                            .font(.title2)
                            .symbolRenderingMode(.monochrome)
                            .foregroundStyle(.orange)

                        VStack(alignment: .leading, spacing: UILayoutValue.layoutValue4.rawValue) {
                            Text("TEMPERATURE")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)

                            HStack {
                                Text(weatherViewModel.cityTemperature)
                                    .font(.system(size: UILayoutValue.layoutValue32.rawValue, weight: .medium, design: .rounded))
                                    // Apply sliding and zooming animations when numerical values change (number change effects)
                                    .contentTransition(.numericText())
                                    .accessibilityIdentifier("cityTemperatureLabel")
                                Text("K")
                                    .font(.system(size: UILayoutValue.layoutValue32.rawValue, weight: .medium, design: .rounded))
                            }
                        }
                    }

                    // Display with capsule tags
                    HStack(alignment: .center, spacing: UILayoutValue.layoutValue16.rawValue) {
                        Image(systemName: "cloud.sun.fill")
                            .font(.title2)
                        // Set the icon rendering to palette mode, sallowing custom settings for two-color layered icon rendering
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.yellow, .blue)

                        VStack(alignment: .leading, spacing: UILayoutValue.layoutValue4.rawValue) {
                            Text("CONDITIONS")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)

                            Text(weatherViewModel.cityDescription.capitalized)
                                .font(.title3)
                                .fontWeight(.medium)
                                .padding(.vertical, UILayoutValue.layoutValue8.rawValue)
                                .padding(.horizontal, UILayoutValue.layoutValue16.rawValue)
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
                    .padding(.bottom, UILayoutValue.layoutValue8.rawValue)
                }
                .padding(.vertical, UILayoutValue.layoutValue20.rawValue)
                .padding(.horizontal, UILayoutValue.layoutValue24.rawValue)
                // semi-transparent frosted effect
                .background(
                    RoundedRectangle(cornerRadius: UILayoutValue.layoutValue24.rawValue)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal, UILayoutValue.layoutValue16.rawValue)
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .alert("load weather error", isPresented: .constant( !isNotShowErrorAlert())) {
            Button("please check error", role: .cancel) { }
        } message: {
            Text(weatherViewModel.errorMessage ?? "unknown error")
        }
        .onChange(of: weatherViewModel.cityTemperature) { _, _ in
            announcementWeatherUpdate()
        }
    }
    
    struct WeatherCardView: View {
        let viewModel: WeatherViewModel
        
        var body: some View {
            VStack(spacing: 20) {
                // 位置信息
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Image(systemName: "location.fill")
                        .font(.title2)
                        .symbolRenderingMode(.multicolor)
                        .foregroundStyle(.blue)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("当前位置")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                            .kerning(0.5)
                        
                        Text(viewModel.cityName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                }
                
                // 温度信息
                HStack(alignment: .center, spacing: 16) {
                    Image(systemName: "thermometer.medium")
                        .font(.title2)
                        .symbolRenderingMode(.monochrome)
                        .foregroundStyle(.orange)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("温度")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        
                        HStack {
                            Text(viewModel.cityTemperature)
                                .font(.system(size: 32, weight: .medium, design: .rounded))
                                .contentTransition(.numericText())
                            Text("K")
                                .font(.system(size: 32, weight: .medium, design: .rounded))
                        }
                    }
                }
                
                // 天气状况
                HStack(alignment: .center, spacing: 16) {
                    Image(systemName: "cloud.sun.fill")
                        .font(.title2)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.yellow, .blue)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("天气状况")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        
                        Text(viewModel.cityDescription.capitalized)
                            .font(.title3)
                            .fontWeight(.medium)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(
                                Capsule()
                                    .fill(.thinMaterial)
                                    .overlay(
                                        Capsule()
                                            .stroke(.quaternary, lineWidth: 1)
                                    )
                            )
                    }
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
        }
    }
    
    private func isNotShowErrorAlert() -> Bool {
        // 判断是否正在加载
//        if !weatherViewModel.isLoaded {
//            return true
//        }
        // 不弹错误窗 温度不为空 && 没有错误  没有正在加载 不弹窗 加载后
        // 只有当isShowingError才会弹 或者当输入不合法时
        // 输入不合法，意味着：weatherViewModel.cityName.isEmpty && weatherViewModel.cityTemperature.isEmpty
        // 但是当isShowingError并且cityName
//        return !weatherViewModel.isShowingError && !weatherViewModel.cityName.isEmpty && !weatherViewModel.cityTemperature.isEmpty
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

    private func fetchWeather() {
        Task {
            weatherViewModel = WeatherViewModel()
            await weatherViewModel.fetchWeatherInfo(cityName: inputCityName)
        }
    }
}

#Preview {
    var weatherViewModel: WeatherViewModel
    ContentView()
}
