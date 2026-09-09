//
//  SelectionView.swift
//  SongLib
//
//  Created by Siro Daves on 04/09/2026.
//

import SwiftUI
import RevenueCatUI

enum SelectionPhase {
    case books
    case songs
}

struct SelectionView: View {
    @StateObject private var viewModel: SelectionViewModel = {
        DiContainer.shared.resolve(SelectionViewModel.self)
    }()
    @EnvironmentObject var themeManager: ThemeManager

    let startPhase: SelectionPhase

    @State private var phase: SelectionPhase
    @State private var showAlertDialog = false
    @State private var showPaywall = false
    @State private var showThemeSheet = false
    @State private var navigateToHome = false

    init(startPhase: SelectionPhase = .books) {
        self.startPhase = startPhase
        self._phase = State(initialValue: startPhase)
    }

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
                .navigationTitle(phase == .books ? "Select Songbooks" : "Syncing Songs")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { if phase == .books { toolbarContent } }
        }
        .alert(isPresented: $showAlertDialog) {
            selectionAlert
        }
        .task { startFlow() }
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

    private func startFlow() {
        switch startPhase {
            case .books:
                viewModel.fetchBooks()
            case .songs:
                viewModel.initializeSongSync()
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
            case .loading, .saving: return true
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
        switch phase {
            case .books:
                booksPhaseContent
            case .songs:
                SongSyncContent(viewModel: viewModel, onRetry: { viewModel.initializeSongSync() })
        }
    }

    @ViewBuilder
    private var booksPhaseContent: some View {
        switch viewModel.uiState {
            case .loading:
                SelectionSkeleton()

            case .saving:
                SplashContent()

            case .error(let msg):
                ErrorView(message: msg) {
                    Task { viewModel.fetchBooks() }
                }

            default:
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
                        viewModel.saveBooks()
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
    
    private func handleStateChange(_ state: UiState) {
        guard case .saved = state else { return }

        switch phase {
            case .books:
                phase = .songs
                viewModel.initializeSongSync()
            case .songs:
                navigateToHome = true
        }
    }
}

#Preview {
    SelectionView()
}
