//
//  HomeView.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI

struct Step2View: View {
    @StateObject private var viewModel: SelectionViewModel = {
        DiContainer.shared.resolve(SelectionViewModel.self)
    }()

    @State private var navigateToNextScreen = false

    var body: some View {
        Group {
            if navigateToNextScreen {
                HomeView()
            } else {
                mainContent
            }
        }
    }

    private var mainContent: some View {
        VStack {
            stateContent
        }
//        .background(.primaryContainer)
        .onAppear {
            viewModel.initializeStep2()
        }
        .onChange(of: viewModel.uiState) { state in
            handleStateChange(state)
        }
    }

    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
        case .loading(let msg):
            LoadingState(
                title: msg ?? "Fetching songs ...",
                fileName: "loading-hand"
            )

        case .saving(let msg):
            VStack {
                LoadingState(
                    title: msg ?? "Saving your songs ...",
                    fileName: "cloud-download",
                    showProgress: true,
                    progressValue: viewModel.progress
                )
                ProgressView(value: Double(viewModel.progress), total: 100)
                    .padding(.top, 12)
            }

        case .error(let msg):
            ErrorState(message: msg) {
                viewModel.initializeStep2()
            }

        case .saved:
            EmptyState()

        default:
            EmptyState()
        }
    }

    private func handleStateChange(_ state: UiState) {
        if case .saved = state {
            navigateToNextScreen = true
        }
    }
}

#Preview {
    Step2View()
}
