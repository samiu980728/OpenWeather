//
//  WeatherLogger.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2025/6/16.
//

import Foundation

import SwiftUI
import os.log

public enum LogLevel: Int {
    // 冗余
    case verbose = 0
    case debug = 1
    case info = 2
    case warning = 3
    case error = 4
}

public struct Logger {
    // 日志级别控制（Debug模式: 显示全部, Release模式: 只显示警告和错误）
    private static let minLogLevel: LogLevel = {
        #if DEBUG
        // .verbose（记录所有日志）
        return .verbose
        #else
        // .warning（过滤冗余信息）
        return .warning
        #endif
    }()
    
    // 获取简洁文件名（去除路径）
    // 完整文件路径 → 简短文件名
    // 转换前​​：/Users/project/ContentView.swift
    // 转换后​​：ContentView.swift
    // 目的：保持日志简洁可读
    private static func simpleFileName(_ file: String) -> String {
        return URL(fileURLWithPath: file).lastPathComponent
    }
    
    // 核心日志方法
    private static func log(_ message: String,
                            level: LogLevel = .debug,
                            file: String = #file,
                            function: String = #function,
                            line: Int = #line) {
        // 日志级别过滤
        // 只打印不低于当前模式最小级别的日志，例如 Release 模式中忽略 verbose/debug/info 级别
        guard level.rawValue >= minLogLevel.rawValue else { return }
        
        // 格式化日志，使用新的更高效的FormatStyle
        // 调用该函数:.formatted()
        // 会提供一个合理的默认值，该默认值使用您设备的当前语言环境和日历来显示该值。
//        let timestamp = dateFormatter.string(from: Date())
        let timestamp = Date().formatted()
        let fileName = simpleFileName(file)
        let logPrefix: String
        
        switch level {
        case .verbose:
            logPrefix = "💬 [VERBOSE]"
        case .debug:
            logPrefix = "🐞 [DEBUG]"
        case .info:
            logPrefix = "ℹ️ [INFO]"
        case .warning:
            logPrefix = "⚠️ [WARNING]"
        case .error:
            logPrefix = "❌ [ERROR]"
        }
        
        // 构建完整日志信息
        // 🐞 [DEBUG] 14:25:03.432 ContentView.swift:18 - onAppear() → 开始加载数据
        let fullMessage = "\(logPrefix) \(timestamp) \(fileName):\(line) - \(function)\n   → \(message)"
        
        // 不同输出方式
        #if DEBUG
        print(fullMessage)
        #else
        // Release模式使用系统日志（优化性能）
        // os_log 是 Apple 推出的​​统一日志系统(Unified Logging System)​​的核心 API，用于替代传统的 NSLog() 和 print()。它包含在 os 模块中，是 Apple 平台(iOS/macOS/watchOS/tvOS)上推荐的日志记录方式。
        // 优点：自动隐藏敏感数据，Instruments/Logging 工具支持，支持多种级别
        // 自动隐藏举例：%{private}@默认只显示<private>(开发者设备解锁可见)，%{sensitive}@默认只显示<redacted>(特殊证书可见)
        // 用户仅可见%{public}@ 打印的内容
        // 文件名和行号不是敏感信息
        os_log("%{public}@", type: .default, fullMessage)
        #endif
    }
    
    // 公开日志方法，这几个参数在调用的时候不用传入，编译器看到后会自动获取
    // #file, #function, #line 是 Swift 编译器指令，自动获取当前代码位置
    // #file  当前代码源文件的完整路径
    // #function  当前方法的名称
    // #line  当前代码行号
    public static func verbose(_ message: String,
                              file: String = #file,
                              function: String = #function,
                              line: Int = #line) {
        log(message, level: .verbose, file: file, function: function, line: line)
    }
    
    public static func debug(_ message: String,
                            file: String = #file,
                            function: String = #function,
                            line: Int = #line) {
        log(message, level: .debug, file: file, function: function, line: line)
    }
    
    public static func info(_ message: String,
                           file: String = #file,
                           function: String = #function,
                           line: Int = #line) {
        log(message, level: .info, file: file, function: function, line: line)
    }
    
    public static func warning(_ message: String,
                               file: String = #file,
                               function: String = #function,
                               line: Int = #line) {
        log(message, level: .warning, file: file, function: function, line: line)
    }
    
    public static func error(_ message: String,
                            file: String = #file,
                            function: String = #function,
                            line: Int = #line) {
        log(message, level: .error, file: file, function: function, line: line)
    }
}
