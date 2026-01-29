//
//  ChineseToEnglishConverter.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2026/1/29.
//

import Foundation

// 中文到英文转换服务
class ChineseToEnglishConverter {
    static let shared = ChineseToEnglishConverter()
    
    private init() {}
    
    // 主要城市的中英文映射表
    private let cityMapping: [String: String] = [
        // 中国主要城市
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
        
        // 国际主要城市
        "纽约": "New York", "伦敦": "London", "巴黎": "Paris", "东京": "Tokyo",
        "悉尼": "Sydney", "新加坡": "Singapore", "首尔": "Seoul", "莫斯科": "Moscow"
    ]
    
    // 将中文城市名转换为英文
    func convertChineseToEnglish(_ input: String) -> String {
        // 1. 首先检查预定义的映射
        if let englishName = cityMapping[input] {
            return englishName
        }
        // 2. 使用拼音转换作为后备方案
        let pinyin = convertToPinyin(input)
        
        // 3. 特殊处理多音字和常见情况
        return postProcessPinyin(pinyin)
    }
    
    // 检查字符串是否包含中文字符
    func containsChineseCharacters(_ text: String) -> Bool {
        return text.range(of: "\\p{Han}", options: .regularExpression) != nil
    }
    
    // 智能城市名处理
    func processCityName(_ cityName: String) -> String {
        if containsChineseCharacters(cityName) {
            return convertChineseToEnglish(cityName)
        }
        return cityName // 如果不是中文，保持原样
    }
    
    // 拼音转换核心方法
    private func convertToPinyin(_ text: String) -> String {
        let mutableString = NSMutableString(string: text) as CFMutableString
        // 转换为拼音
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        // 去除音调
        CFStringTransform(mutableString, nil, kCFStringTransformStripCombiningMarks, false)
        // 处理结果
        let pinyin = (mutableString as String)
            .replacingOccurrences(of: " ", with: "")
            .lowercased()
        return pinyin
    }
    
    // 拼音后处理
    private func postProcessPinyin(_ pinyin: String) -> String {
        var result = pinyin
        
        // 处理常见的多音字
        let polyphonicMapping: [String: String] = [
            "chongqing": "chongqing",  // 重庆
            "xian": "xi'an",           // 西安
            "hefei": "hefei",          // 合肥
            "zhangzhou": "zhangzhou",  // 漳州
            "changzhou": "changzhou"   // 常州
        ]
        
        // 应用多音字映射
        for (key, value) in polyphonicMapping {
            if result == key {
                result = value
                break
            }
        }
        
        // 首字母大写（城市名格式）
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
