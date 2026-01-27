//
//  README.md
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2026/1/27.
//

🌤️ Weather App
A weather query application developed with SwiftUI, providing accurate weather information based on the OpenWeather API.
✨ Features
🔍 City Weather Query​ - Enter city name to get real-time weather data
🎨 Modern Interface​ - Elegant user interface designed with SwiftUI
♿ Accessibility Support​ - Full VoiceOver and dynamic font support
📱 Responsive Design​ - Adapts to various screen sizes and device orientations
🌡️ Temperature Display​ - Shows current temperature and weather condition description
⚡ Real-time Updates​ - Voice announcement when temperature changes
🔒 Error Handling​ - Comprehensive network error and exception handling

🏗️ Project Structure
ProjectTest-OpenWeather/
├── Views/
│   ├── ContentView.swift          # Main interface view
│   └── ClearButtonViewModifer.swift # Clear button modifier
├── ViewModels/
│   └── WeatherViewModel.swift     # Weather view model
├── Models/
│   ├── WeatherResponseModel.swift # Weather response model
│   ├── WeatherGeocodingModel.swift # Geocoding model
│   ├── CurrentWeatherModel.swift  # Current weather model
│   └── WeatherLogger.swift        # Logging utility
├── Repositories/
│   ├── WeatherRepository.swift    # Weather repository protocol
│   └── DefaultWeatherRepository.swift # Default repository implementation
├── DataSources/
│   └── WeatherDataSource.swift    # Data source protocol and implementation
└── Tests/
    ├── ProjectTest_OpenWeatherSwiftTestingTests.swift
    └── WeatherViewModelTests.swift

📖 Usage Guide
Basic Operations
Enter City Name​ - Type the city name in the text field
Clear Input​ - Click the clear button on the right side of the input field
Query Weather​ - Click "Load Weather Data" button to get weather information
View Results​ - Display city name, temperature, and weather conditions after successful query

Accessibility Features
VoiceOver Support: All UI elements include appropriate accessibility identifiers
Dynamic Fonts: Support for system font size settings
Voice Announcement: Automatic weather information announcement when temperature updates
