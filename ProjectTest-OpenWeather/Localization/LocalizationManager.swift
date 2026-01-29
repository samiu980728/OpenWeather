//
//  LocalizationManager.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2026/1/29.
//

import Foundation

// 本地化工具
class LocalizationManager {
    static let shared = LocalizationManager()
    private init() {}
    
    // 支持的语言类型
    enum LanguageType: String, CaseIterable {
        case english = "en"
        case chinese = "zh-Hans"
        
        var displayName: String {
            switch self {
            case .english: return "English"
            case .chinese: return "中文"
            }
        }
    }
    
    // 当前语言
    var currentLanguage: LanguageType {
        get {
            if let saved = UserDefaults.standard.string(forKey: "selectedLanguage"),
               let language = LanguageType(rawValue: saved) {
                return language
            }
            return LanguageType.english
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedLanguage")
        }
    }
}

// 字符串扩展简化本地化
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
