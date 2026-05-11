//
//  SettingsForm.swift
//  SongLib
//
//  Created by Siro Daves on 26/08/2025.
//

import SwiftUI

struct SettingsForm: View {
    @ObservedObject var viewModel: MainViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var showPaywall: Bool
    @Binding var showResetAlert: Bool
    
    var body: some View {
        Form {
            SettingsSection(header: "App Theme") {
                Picker("Select your Theme", selection: $themeManager.selectedTheme) {
                    ForEach(AppThemeMode.allCases) { mode in
                        Text(mode.displayName).tag(mode)
                    }
                }
            }

            SettingsSection(header: "Song Slides") {
                SettingsRow(
                    systemImage: "arrow.left.and.right",
                    title: "Song Slides",
                    subtitle: "Swipe verses horizontally",
                    trailing:  {
                        Toggle("", isOn: Binding(
                            get: { viewModel.horizontalSlides },
                            set: { viewModel.updateSlides(value: $0) }
                        ))
                        .labelsHidden()
                    }
                )
            }

            #if !DEBUG
            if !viewModel.isProUser {
                SettingsSection(header: "SongLib Pro") {
                    SettingsRow(
                        systemImage: "star.fill",
                        title: L10n.joinPro,
                        subtitle: L10n.joinProDesc,
                        foregroundColor: .yellow,
                        action: { showPaywall = true }
                    )
                }
            }
            #endif

            SettingsSection(header: "Feedback") {
                SettingsRow(
                    systemImage: "text.badge.star",
                    title: L10n.leaveReview,
                    subtitle: L10n.leaveReviewDesc,
                    action: viewModel.promptReview
                )
                SettingsRow(
                    systemImage: "envelope",
                    title: L10n.contactUs,
                    subtitle: L10n.contactUsDesc,
                    action: AppUtils.sendEmail
                )
            }

            SettingsSection(header: "DANGER") {
                SettingsRow(
                    systemImage: "exclamationmark.triangle.fill",
                    title: L10n.resetData,
                    subtitle: L10n.resetDataDesc,
                    foregroundColor: .red,
                    action: { showResetAlert = true }
                )
            }
        }
    }
}
