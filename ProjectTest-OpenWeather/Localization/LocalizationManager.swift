//
//  LocalizationManager.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2026/1/29.
//

import Foundation

// localization tool
class LocalizationManager {
    static let shared = LocalizationManager()
    private init() {}
    
    // Supported language types
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
    
    // Current Language
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

// String expansion simplifies localization
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
