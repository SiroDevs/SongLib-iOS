//
//  AppFonts.swift
//  SongLib
//
//  Created by Siro Daves on 11/09/2026.
//

import Foundation

/// Verse font-size bounds used by the presenter's pinch-to-zoom gesture.
/// Mirrors the Android app's `AppFonts` constants so slides feel the same
/// size on both platforms.
enum AppFonts {
    static let minSize: CGFloat = 14
    static let maxSize: CGFloat = 60
    static let defaultSize: CGFloat = 28
}
