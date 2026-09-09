//
//  ThemeSelectorSheet.swift
//  SongLib
//
//  Created by Siro Daves on 04/09/2026.
//

import SwiftUI

struct ThemeSelectorSheet: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(AppThemeMode.allCases) { mode in
                Button {
                    themeManager.selectedTheme = mode
                    dismiss()
                } label: {
                    HStack {
                        Text(mode.displayName)
                            .foregroundColor(.primary)
                        Spacer()
                        if themeManager.selectedTheme == mode {
                            Image(systemName: "checkmark")
                                .foregroundColor(.primary1)
                        }
                    }
                }
            }
            .navigationTitle("App Theme")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }
}
