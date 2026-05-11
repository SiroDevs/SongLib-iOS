//
//  Step1View.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI
import RevenueCatUI

struct Step1View: View {
    @StateObject private var viewModel: SelectionViewModel = {
        DiContainer.shared.resolve(SelectionViewModel.self)
    }()
    @State private var showAlertDialog = false
    @State private var showPaywall: Bool = false
    @State private var navigateToNextScreen = false

    var body: some View {
        Group {
            if navigateToNextScreen {
                AnyView(Step2View())
            } else {
                AnyView(mainContent)
            }
        }
        .alert("You selected more than 3 ...",
               isPresented: $viewModel.showProLimitAlert) {
            proLimitAlertButtons
        } message: {
            Text("Please purchase a subscription if you want to have more than 3 songbooks collection.")
        }
    }
    
    private var mainContent: some View {
        VStack {
            Text("Select Songbooks")
                .font(.title2)
                .foregroundColor(.onPrimaryContainer)
            stateContent.background(.surface)
        }
        .background(.primaryContainer)
        .alert(isPresented: $showAlertDialog) {
            selectionAlert
        }
        .task({ viewModel.fetchBooks() })
        .onChange(of: viewModel.uiState, perform: handleStateChange)
        .sheet(isPresented: $showPaywall) {
            #if !DEBUG
            PaywallView(displayCloseButton: true)
            #endif
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
            case .loading(let msg):
                LoadingState(
                    title: msg ?? "Loading books ...",
                    fileName: "loading-hand"
                )
                
            case .saving(let msg):
                LoadingState(
                    title: msg ?? "Loading books ...",
                    fileName: "cloud-download"
                )
                
            case .saved:
                LoadingView()
                
            case .error(let msg):
                ErrorView(message: msg) {
                    Task { viewModel.fetchBooks() }
                }
                
            default:
                Step1Content(
                    viewModel: viewModel,
                    showAlertDialog: $showAlertDialog
                )
        }
    }
    
    private var selectionAlert: Alert {
        if viewModel.selectedBooks().isEmpty {
            Alert(
                title: Text("Oops! No selection found"),
                message: Text("Please select at least 1 songbook to proceed to the next step."),
                dismissButton: .default(Text("OKAY")),
            )
        } else {
            if !viewModel.isProUser && viewModel.selectedBooks().count > 3 {
                Alert(
                    title: Text("You selected more than 3 ..."),
                    message: Text("Please purchase a subscription if you want to have more than 3 songbooks in your collection."),
                    primaryButton: .default(Text("CANCEL")) {
                        deselectLastBook()
                    },
                    secondaryButton: .default(Text("OKAY")) {
                        showPaywall = true
                    }
                )
            } else {
                Alert(
                    title: Text("Are you done selecting?"),
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
        navigateToNextScreen = .saved == state
    }
}
