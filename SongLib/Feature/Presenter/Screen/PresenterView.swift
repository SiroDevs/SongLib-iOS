//
//  PresenterView.swift
//  SongLib
//
//  Created by Siro Daves on 06/05/2025.
//

import SwiftUI
import SwiftUIPager

struct PresenterView: View {
    @StateObject private var viewModel: ListingViewModel = {
        DiContainer.shared.resolve(ListingViewModel.self)
    }()
    let song: Song
    var songs: [Song] = []

    @StateObject private var selectedPage = Page.first()
    @State private var toastMessage: String?

    var body: some View {
        ZStack {
            NavigationStack {
                stateContent
            }

            if let toastMessage {
                ToastView(message: toastMessage)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .task {
            viewModel.loadSong(song: song, context: songs.isEmpty ? [song] : songs)
        }
        .onChange(of: viewModel.uiState) { newState in
            if case .liked = newState {
                let likedTitle = viewModel.currentSong?.title ?? song.title
                showToast(L10n.likedSong(for: likedTitle, isLiked: viewModel.isLiked))
            }
        }
    }

    private func showToast(_ message: String) {
        toastMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            toastMessage = nil
        }
    }

    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
            case .loading:
                ProgressView()
                    .scaleEffect(5)
                    .tint(.onPrimary)
                
            case .loaded, .liked, .saved:
                PresenterContent(
                    viewModel: viewModel,
                    selected: selectedPage,
                    song: song,
                    onToast: showToast
                )

            case .error(let msg):
                ErrorView(message: msg) {
                    Task { viewModel.loadSong(song: song, context: songs.isEmpty ? [song] : songs) }
                }

            default:
                LoadingView()
        }
    }
}

#Preview{
    PresenterView(
        song: Song.sampleSongs[0],
    )
}
