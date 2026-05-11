//
//  ThemeManager.swift
//  SongLib
//
//  Created by Siro Daves on 05/08/2025.
//

import SwiftUI

enum AppThemeMode: String, CaseIterable, Identifiable {
    case light, dark, system
    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .light: return "Light Theme"
        case .dark: return "Dark Theme"
        case .system: return "System Default"
        }
    }
}

final class ThemeManager: ObservableObject {
    @AppStorage("selectedTheme") private var selectedThemeRaw: String = AppThemeMode.system.rawValue

    var selectedTheme: AppThemeMode {
        get { AppThemeMode(rawValue: selectedThemeRaw) ?? .system }
        set { selectedThemeRaw = newValue.rawValue }
    }
}
