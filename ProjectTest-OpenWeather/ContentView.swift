//
//  ContentView.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2025/3/21.
//

import SwiftUI

// TODO 语音voiceover正常了但是还有遗留的一些问题没有解决，同时各种错误处理也不太好 需要提高。还得再重新看一下MVVM的实现，有没有问题
struct ContentView: View {
    @StateObject private var weatherViewModel = WeatherViewModel()
    
    @State private var inputCityName = "London"
    
    @State private var isShowAlert = false
    
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
                // 输入区域
                HStack(spacing: UILayoutValue.layoutValue12.rawValue) {
                    Image(systemName: "map.fill")
                        .font(.headline)
                        .foregroundColor(.blue)
                    TextField("Enter city name", text: $inputCityName)
                        .padding(UILayoutValue.layoutValue12.rawValue)
                        .background(Color(.systemGray6))
                        .cornerRadius(UILayoutValue.layoutValue12.rawValue)
                    // 在视图上方叠加一个细线描边的圆角矩形
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
                // 设置水平方向（左右两侧）的内边距为 16
                .padding(.horizontal, UILayoutValue.layoutValue16.rawValue)
                
                // 加载按钮
                Button(action: fetchWeather) {
                    Text("Load Weather Data")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, UILayoutValue.layoutValue12.rawValue)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(UILayoutValue.layoutValue12.rawValue)
                    // 设置视图的可点击区域为矩形
                    // 即使按钮内部有空隙，点击整个矩形区域都会触发按钮
                        .contentShape(Rectangle()) // 确保整个区域可点击
                }
                // 设置按钮样式为"无样式"
                .buttonStyle(PlainButtonStyle()) // 禁用默认按钮样式
                .disabled(inputCityName.isEmpty) // 无输入时禁用按钮
                .padding(.horizontal, UILayoutValue.layoutValue20.rawValue)
                .accessibilityIdentifier("searchButton")
                .accessibilityLabel("searchButtonLabel")
                .accessibilityHint("search city temperature")
            }
            .padding(.vertical, UILayoutValue.layoutValue20.rawValue)
            // .fill(Color(.secondarySystemBackground))：填充系统定义的次要背景色（自适应明暗模式）
            // 给视图添加一个有圆角和阴影的背景层
            .background(
                RoundedRectangle(cornerRadius:  UILayoutValue.layoutValue20.rawValue)
                    .fill(Color(.secondarySystemBackground))
                    .shadow(radius: 5)
            )
            .padding(.horizontal,  UILayoutValue.layoutValue16.rawValue)
            
            /* 尝试美化一下界面， 比如字体大小， 布局
             TextField 加上Border
             Button 使用.buttonStyle Modifier等等
             */
            if let error = weatherViewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            
            if weatherViewModel.isLoading {
                ProgressView()
            } else if !weatherViewModel.cityName.isEmpty {
                VStack(spacing:  UILayoutValue.layoutValue16.rawValue) {
                    // 城市名称行 - 添加图标和垂直布局
                    HStack(alignment: .firstTextBaseline, spacing:  UILayoutValue.layoutValue12.rawValue) {
                        Image(systemName: "location.fill")
                            .font(.title2)
                        // 含义​​：设置 SF Symbols 图标的渲染模式为"多色模式" 效果​​：图标会使用其预设的多种颜色（例如警告标志会是黄色三角形加红色惊叹号） 使用场景​​：用于强调重要图标时，如警告、成功提示等
                            .symbolRenderingMode(.multicolor)
                            .foregroundStyle(.blue)
                        
                        VStack(alignment: .leading, spacing:  UILayoutValue.layoutValue4.rawValue) {
                            // 设置文本使用标题样式字体
                            // ​​设置文本字体粗细为半粗体
                            Text("CURRENT LOCATION")
                                .font(.caption)
                                .fontWeight(.semibold)
                            // ​​效果​​：使用系统定义的次要文本颜色（通常是灰色）
                                .foregroundStyle(.secondary)
                            // 字距调整
                                .kerning(0.5)
                            
                            Text(weatherViewModel.cityName)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .lineLimit(1)
                            // ​​设置文本的最小缩放比例因子为 0.8
                            // 当文本超出视图边界时，自动缩小至原始大小的 80%
                                .minimumScaleFactor(0.8)
                                .accessibilityIdentifier("cityNameLabel")

                        }
                    }
                    .padding(.top,  UILayoutValue.layoutValue8.rawValue)
                    
                    // 温度行 - 增加强调效果
                    HStack(alignment: .center, spacing:  UILayoutValue.layoutValue16.rawValue) {
                        // 设置图标渲染为单色，图标将仅使用单一颜色（通常是前景色）
                        Image(systemName: "thermometer.medium")
                            .font(.title2)
                            .symbolRenderingMode(.monochrome)
                            .foregroundStyle(.orange)
                        
                        VStack(alignment: .leading, spacing:  UILayoutValue.layoutValue4.rawValue) {
                            Text("TEMPERATURE")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                            
                            HStack {
                                Text(weatherViewModel.cityTemperature)
                                    .font(.system(size:  UILayoutValue.layoutValue32.rawValue, weight: .medium, design: .rounded))
                                // 设置内容过渡类型为数值文本过渡
                                // 当数值变化时应用滑动和缩放动画（数字变化特效）
                                // 使用场景​​：温度、数值等动态变化的文本
                                    .contentTransition(.numericText()) // 添加温度变化动画
                                    .accessibilityIdentifier("cityTemperatureLabel")
                                Text("K")
                                    .font(.system(size:  UILayoutValue.layoutValue32.rawValue, weight: .medium, design: .rounded))
                            }
                        }
                    }
                    
                    // 天气描述行 - 用胶囊标签展示
                    HStack(alignment: .center, spacing:  UILayoutValue.layoutValue16.rawValue) {
                        Image(systemName: "cloud.sun.fill")
                            .font(.title2)
                        // 设置图标渲染为调色板模式，可以自定义设置两种颜色分层渲染图标
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.yellow, .blue)
                        
                        VStack(alignment: .leading, spacing:  UILayoutValue.layoutValue4.rawValue) {
                            Text("CONDITIONS")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                            
                            // capitalized 大写
                            Text(weatherViewModel.cityDescription.capitalized)
                                .font(.title3)
                                .fontWeight(.medium)
                                .padding(.vertical,  UILayoutValue.layoutValue8.rawValue)
                                .padding(.horizontal,  UILayoutValue.layoutValue16.rawValue)
                                .background(
                                    // 胶囊形状容器
                                    Capsule()
                                    // 填充材质
                                        .fill(.thinMaterial)
                                    // 叠加描边效果
                                        .overlay(
                                            // 另一个相同形状的胶囊
                                            Capsule()
                                                .stroke(.quaternary, lineWidth: 1)
                                        )
                                )
                                .accessibilityIdentifier("cityDescriptionLabel")
                        }
                    }
                    .padding(.bottom,  UILayoutValue.layoutValue8.rawValue)
                }
                .padding(.vertical,  UILayoutValue.layoutValue20.rawValue)
                .padding(.horizontal,  UILayoutValue.layoutValue24.rawValue)
                // 使用超薄材质填充（半透明磨砂效果）
                .background(
                    RoundedRectangle(cornerRadius:  UILayoutValue.layoutValue24.rawValue)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal,  UILayoutValue.layoutValue16.rawValue)
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .alert("load weather error", isPresented: $weatherViewModel.isShowingError) {
            /* Button 的Action 为空 花括号写在一行里 */
            Button("please check error", role: .cancel) { }
        } message: {
            Text(weatherViewModel.errorMessage ?? "unknown error")
        }
        .onChange(of: weatherViewModel.cityTemperature) { oldValue, newValue in
            announcementWeatherUpdate()
        }
    }
    
    private func announcementWeatherUpdate() {
        let message = "\(weatherViewModel.cityName) temperature is \(weatherViewModel.cityTemperature)"
        AccessibilityNotification.Announcement(message).post()
        // 传统方式 (兼容旧版本)
//            UIAccessibility.post(notification: .announcement, argument: announcement)
    }
    
    private func fetchWeather() {
        Task {
            await weatherViewModel.fetchWeatherInfo(cityName: inputCityName)
        }
    }
}

#Preview {
    var weatherViewModel: WeatherViewModel
    ContentView()
}
