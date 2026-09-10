//
//  SelectionView.swift
//  SongLib
//
//  Created by Siro Daves on 04/09/2026.
//

import SwiftUI
import RevenueCatUI

struct SelectionView: View {
    @StateObject private var viewModel: SelectionViewModel = {
        DiContainer.shared.resolve(SelectionViewModel.self)
    }()
    @EnvironmentObject var themeManager: ThemeManager

    @State private var showAlertDialog = false
    @State private var showPaywall = false
    @State private var showThemeSheet = false
    @State private var navigateToHome = false

    var body: some View {
        Group {
            if navigateToHome {
                HomeView()
            } else {
                mainContent
            }
        }
        .alert("You selected more than 4 ...",
               isPresented: $viewModel.showProLimitAlert) {
            proLimitAlertButtons
        } message: {
            Text("Please purchase a subscription if you want to have more than 4 songbooks your collection.")
        }
    }

    private var mainContent: some View {
        NavigationStack {
            stateContent
                .background(.surface)
                .navigationTitle("Select Songbooks")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { toolbarContent }
        }
        .alert(isPresented: $showAlertDialog) {
            selectionAlert
        }
        .task { viewModel.fetchBooks() }
        .onChange(of: viewModel.uiState, perform: handleStateChange)
        .sheet(isPresented: $showPaywall) {
            #if !DEBUG
            PaywallView(displayCloseButton: true)
            #endif
        }
        .sheet(isPresented: $showThemeSheet) {
            ThemeSelectorSheet()
                .environmentObject(themeManager)
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            if !isBusy {
                Button {
                    viewModel.fetchBooks()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }

            Button {
                showThemeSheet = true
            } label: {
                Image(systemName: "circle.lefthalf.filled")
            }
        }
    }

    private var isBusy: Bool {
        switch viewModel.uiState {
            case .loading: return true
            default: return false
        }
    }

    private var proLimitAlertButtons: some View {
        Group {
            Button("CANCEL", role: .cancel) {
                deselectLastBook()
            }
            Button("OKAY") {
                showPaywall = true
            }
        }
    }

    private func deselectLastBook() {
        if let lastSelectedIndex = viewModel.books.lastIndex(where: { $0.isSelected }) {
            viewModel.books[lastSelectedIndex].isSelected = false
        }
    }

    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
            case .loading:
                SelectionSkeleton()

            case .error(let msg):
                ErrorView(message: msg) {
                    Task { viewModel.fetchBooks() }
                }

            default:
                // No dedicated "saving" screen — matches Android, which
                // just flips straight to Home once the selection is
                // persisted. The book grid stays put underneath the alert
                // for the brief moment saveBooks() is writing locally.
                BooksGridContent(
                    viewModel: viewModel,
                    showAlertDialog: $showAlertDialog
                )
        }
    }

    private var selectionAlert: Alert {
        if viewModel.selectedBooks().isEmpty {
            Alert(
                title: Text("Oops! No selection found"),
                message: Text("Please select at least 1 songbook to proceed."),
                dismissButton: .default(Text("OKAY")),
            )
        } else {
            if !viewModel.isProUser && viewModel.selectedBooks().count > 4 {
                Alert(
                    title: Text("You selected more than 4 ..."),
                    message: Text("Please purchase a subscription if you want to have more than 4 songbooks in your collection."),
                    primaryButton: .default(Text("CANCEL")) {
                        deselectLastBook()
                    },
                    secondaryButton: .default(Text("OKAY")) {
                        showPaywall = true
                    }
                )
            } else {
                Alert(
                    title: Text("Done selecting?"),
                    message: Text("If you are done selecting please proceed ahead. We can always bring you back here to reselect afresh."),
                    primaryButton: .default(Text("CANCEL")),
                    secondaryButton: .default(Text("OKAY")) {
                        viewModel.saveBooks()
                    }
                )
            }
        }
    }

    /// Books are persisted locally (fast, no network) — as soon as that's
    /// done we go straight to Home, same as Android. Song syncing itself
    /// happens silently afterward, kicked off here but never observed by
    /// this view again (HomeView/MainViewModel picks it up independently
    /// too, so this just gets it started immediately rather than waiting
    /// for Home's own .task to notice isDataLoaded is false).
    private func handleStateChange(_ state: UiState) {
        guard !navigateToHome, case .saved = state else { return }
        navigateToHome = true
        viewModel.syncSongsInBackground()
    }
}

#Preview {
    SelectionView()
}
