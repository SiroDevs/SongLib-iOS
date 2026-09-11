//
//  HomeTopBarActions.swift
//  SongLib
//
//  Created by Siro Daves on 11/09/2026.
//

import SwiftUI

/// Drafts icon + "More" overflow menu (App Settings / How It Works /
/// Help & Feedback), shown on every Home tab's own top bar - mirrors
/// Android's `HomeOverflowMenu`, minus the account-only items iOS doesn't
/// have (casting, profile). Drafts used to be its own tab; now it's this
/// icon, so it's reachable from Search, Likes, and Listings alike.
private struct HomeTopBarActions: ViewModifier {
    @ObservedObject var viewModel: MainViewModel

    @State private var showDrafts = false
    @State private var showSettings = false
    @State private var showHowItWorks = false
    @State private var showHelp = false

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showDrafts = true
                    } label: {
                        Image(systemName: "doc.text")
                    }

                    Menu {
                        Button {
                            showSettings = true
                        } label: {
                            Label("App Settings", systemImage: "gearshape")
                        }

                        Button {
                            showHowItWorks = true
                        } label: {
                            Label("How It Works", systemImage: "info.circle")
                        }

                        Button {
                            showHelp = true
                        } label: {
                            Label("Help & Feedback", systemImage: "questionmark.circle")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showDrafts) {
                DraftsScreen()
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(viewModel: viewModel)
            }
            .sheet(isPresented: $showHowItWorks) {
                HowItWorksView()
            }
            .sheet(isPresented: $showHelp) {
                HelpFeedbackView()
            }
    }
}

extension View {
    /// Attaches the shared Drafts + More toolbar to a Home tab's own
    /// `NavigationStack` root.
    func homeToolbar(viewModel: MainViewModel) -> some View {
        modifier(HomeTopBarActions(viewModel: viewModel))
    }
}
