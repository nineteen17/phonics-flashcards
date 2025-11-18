//
//  ThemeManager.swift
//  phonics-flashcards
//
//  Created by Claude on 18/11/2025.
//

import SwiftUI

/// Theme appearance options
enum AppTheme: String, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

    var icon: String {
        switch self {
        case .system:
            return "circle.lefthalf.filled"
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        }
    }
}

/// Manages app theme preferences
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    @AppStorage("app_theme") var currentTheme: String = AppTheme.system.rawValue

    private init() {}

    var theme: AppTheme {
        get {
            AppTheme(rawValue: currentTheme) ?? .system
        }
        set {
            currentTheme = newValue.rawValue
        }
    }
}
