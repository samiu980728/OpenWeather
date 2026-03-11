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
            WeatherSearchView(
                weatherViewModel: $weatherViewModel,
                inputCityName: $inputCityName
            )
            .padding(.horizontal)
            .background(.ultraThinMaterial)
            // Make sure that at the topmost layer, if no zIndex is set, it defaults to 0.
            // Setting a value greater than 0 (such as 1) is a straightforward and effective way to achieve the floating or top-stacked effect.
            .zIndex(1)

            VStack(spacing: 0) {
                // Reserved space, small gap
                Color.clear.frame(height: 8)
                if !inputCityName.isEmpty &&
                    !weatherViewModel.cityName.isEmpty &&
                    !weatherViewModel.cityTemperature.isEmpty {
                    WeatherCardView(weatherViewModel: weatherViewModel)
                }
                Spacer(minLength: 0)
            }
            .padding(.top, 8)
        }
        .alert("load weather error", isPresented: Binding(
                get: {
                    return !isNotShowErrorAlert()
                },
                set: { _ in }
        )) {
            Button("please check error", role: .cancel) {
                // reset weatherViewModel
                weatherViewModel = WeatherViewModel()
            }
        } message: {
            Text(weatherViewModel.errorMessage ?? "unknown error")
        }
        .onChange(of: weatherViewModel.cityTemperature) { _, _ in
            announcementWeatherUpdate()
        }
    }
    
    private func isNotShowErrorAlert() -> Bool {
        // When there is no error reported by the weather interface, do not display the error window.
        if weatherViewModel.isShowingError {
            return false
        }
        // When the weather interface call is successful and the returned temperature is empty, display the error window.
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
                    // Set the text font weight to semi-bold
                    Text("current_location".localized)
                        .font(.caption)
                        .fontWeight(.semibold)
                        // Use the system-defined secondary text color (usually gray)
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
                    Text("temperature".localized)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Text(weatherViewModel.getCelsiusTemperature())
                            .font(.system(size: CGFloat.layoutValue32, weight: .medium, design: .rounded))
                            // Apply sliding and zooming animations when numerical values change (number change effects)
                            .contentTransition(.numericText())
                            .accessibilityIdentifier("cityTemperatureLabel")
                        Text("°")
                            .font(
                                .system(
                                    size: CGFloat.layoutValue32,
                                    weight: .medium,
                                    design: .rounded
                                )
                            )
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
                    Text("weather_conditions".localized)
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
