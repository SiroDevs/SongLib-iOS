//
//  SongSyncContent.swift
//  SongLib
//
//  Created by Siro Daves on 04/09/2026.
//

import SwiftUI

/// Fetch-and-save-songs progress UI.
/// Used by SelectionView while it's in the `.songs` phase.
struct SongSyncContent: View {
    @ObservedObject var viewModel: SelectionViewModel
    let onRetry: () -> Void

    var body: some View {
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
                ErrorState(message: msg, retryAction: onRetry)

            default:
                EmptyState()
        }
    }
}
