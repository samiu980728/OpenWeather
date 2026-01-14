//
//  WeatherDetailView.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2025/6/13.
//

import SwiftUI

// 这个目前没有用到，后续可以考虑用到
struct WeatherDetailView: View {
    let cityName: String
    let temperature: String
    let description: String
            
    var body: some View {
        VStack {
            HStack {
                Text("city name：")
                    .font(.largeTitle)
                Text(cityName)
                    .font(.largeTitle)
            }
            HStack {
                Text("temperature：")
                    .font(.headline)
                Text(temperature)
                    .font(.headline)
            }
            HStack {
                Text("description：")
                    .font(.subheadline)
                Text(description)
                    .font(.subheadline)
            }
        }
        .padding()
       }
}
