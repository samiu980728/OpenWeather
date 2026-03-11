//
//  WeatherSearchView.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2026/3/9.
//

import SwiftUI

struct WeatherSearchView: View {
    @Binding var weatherViewModel: WeatherViewModel
    @Binding var inputCityName: String
    
    var body: some View {
        VStack(spacing: CGFloat.layoutValue20) {
            // Enter the name of the city
            HStack(spacing: CGFloat.layoutValue12) {
                Image(systemName: "map.fill")
                    .font(.headline)
                    .foregroundColor(.blue)
                TextField("enter_city_name".localized, text: $inputCityName)
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
                Text("search_weather".localized)
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
            await weatherViewModel.fetchWeatherInfo(cityName: inputCityName.toEnglishCityName)
        }
    }
}
