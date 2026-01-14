//
//  ClearButtonViewModifer.swift
//  ProjectTest-OpenWeather
//
//  Created by 景鹏旭 on 2026/1/13.
//

import SwiftUI

struct ClearButtonViewModifer: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.secondary)
                }
                .accessibilityIdentifier("clearButton")
                .accessibilityLabel("clearButtonLabel")
                .accessibilityHint("clear city name")
            }
        }
    }
}

extension View {
    func clearButton(text: Binding<String>) -> some View {
        self.modifier(ClearButtonViewModifer(text: text))
    }
}
