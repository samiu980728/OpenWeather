//
//  LocalizationManager.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2026/1/29.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
