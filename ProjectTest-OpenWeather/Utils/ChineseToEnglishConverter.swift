//
//  ChineseToEnglishConverter.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2026/1/29.
//

import Foundation

// English translation service from Chinese
class ChineseToEnglishConverter {
    static let shared = ChineseToEnglishConverter()
    
    private init() {}
    
    // Mapping table of Chinese and English for major cities
    private let cityMapping: [String: String] = [
        // major cities in china
        "北京": "Beijing", "上海": "Shanghai", "广州": "Guangzhou",
        "深圳": "Shenzhen", "杭州": "Hangzhou", "成都": "Chengdu",
        "武汉": "Wuhan", "西安": "Xi'an", "南京": "Nanjing", "重庆": "Chongqing",
        "天津": "Tianjin", "苏州": "Suzhou", "厦门": "Xiamen", "青岛": "Qingdao",
        "长沙": "Changsha", "郑州": "Zhengzhou", "福州": "Fuzhou", "济南": "Jinan",
        "大连": "Dalian", "宁波": "Ningbo", "无锡": "Wuxi", "合肥": "Hefei",
        "昆明": "Kunming", "哈尔滨": "Harbin", "沈阳": "Shenyang", "长春": "Changchun",
        "太原": "Taiyuan", "石家庄": "Shijiazhuang", "兰州": "Lanzhou", "乌鲁木齐": "Urumqi",
        "贵阳": "Guiyang", "南宁": "Nanning", "海口": "Haikou", "拉萨": "Lhasa",
        "香港": "Hong Kong", "澳门": "Macau", "台北": "Taipei", "高雄": "Kaohsiung",
        
        // Major International Cities
        "纽约": "New York", "伦敦": "London", "巴黎": "Paris", "东京": "Tokyo",
        "悉尼": "Sydney", "新加坡": "Singapore", "首尔": "Seoul", "莫斯科": "Moscow"
    ]
    
    // Convert the name of the Chinese city to English.
    func convertChineseToEnglish(_ input: String) -> String {
        // 1. First, check the predefined mappings
        if let englishName = cityMapping[input] {
            return englishName
        }
        // 2. Use pinyin conversion as a backup option
        let pinyin = convertToPinyin(input)
        
        // 3. Special handling of polyphonic characters and common situations
        return postProcessPinyin(pinyin)
    }
    
    // Check if the string contains Chinese characters
    func containsChineseCharacters(_ text: String) -> Bool {
        return text.range(of: "\\p{Han}", options: .regularExpression) != nil
    }
    
    // Intelligent City Name Processing
    func processCityName(_ cityName: String) -> String {
        if containsChineseCharacters(cityName) {
            return convertChineseToEnglish(cityName)
        }
        return cityName // If it is not in Chinese, keep it as it is.
    }
    
    // The core method of pinyin conversion
    private func convertToPinyin(_ text: String) -> String {
        let mutableString = NSMutableString(string: text) as CFMutableString
        // Translate into pinyin
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        // Remove the tone
        CFStringTransform(mutableString, nil, kCFStringTransformStripCombiningMarks, false)
        // handle result
        let pinyin = (mutableString as String)
            .replacingOccurrences(of: " ", with: "")
            .lowercased()
        return pinyin
    }
    
    // Post-processing of pinyin
    private func postProcessPinyin(_ pinyin: String) -> String {
        var result = pinyin
        
        // Handling common polyphonic characters
        let polyphonicMapping: [String: String] = [
            "chongqing": "chongqing",  // Chongqing
            "xian": "xi'an",           // Xi'an
            "hefei": "hefei",          // Hefei
            "zhangzhou": "zhangzhou",  // Zhangzhou
            "changzhou": "changzhou"   // Changzhou
        ]
        
        // Apply multi-sound character mapping
        for (key, value) in polyphonicMapping {
            if result == key {
                result = value
                break
            }
        }
        
        // Capital lettered (city name format)
        return result.capitalized
    }
}

// String 扩展
extension String {
    var containsChinese: Bool {
        return ChineseToEnglishConverter.shared.containsChineseCharacters(self)
    }
    
    var toEnglishCityName: String {
        return ChineseToEnglishConverter.shared.processCityName(self)
    }
}
