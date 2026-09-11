//
//  SongsList.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import SwiftUI
import RevenueCatUI

struct SongsList: View {
    @ObservedObject var viewModel: HomeViewModel
    let songs: [Song]

    @State private var selectedSong: Song?
    @State private var showToast = false
    @State private var toastMessage: String = ""
    @State private var showPaywall = false
    @State private var showProLimit = false
    
    var body: some View {
        ZStack {
            stateContent

            if showToast {
                ToastView(message: toastMessage)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .sheet(item: $selectedSong) { song in
            ChooseListingSheet(
                listings: viewModel.listings,
                onSelect: { listing in
                    addSongToListing(song: song, listing: listing)
                },
                onNewList: { title in
                    // Check if user can create new listing
                    if canCreateNewListing() {
                        viewModel.saveListing(0, title: title)
                        if let newListing = viewModel.listings.last {
                            addSongToListing(song: song, listing: newListing)
                        }
                    } else {
                        showProLimit = true
                    }
                }
            )
        }
        .alert("Support us by upgrading", isPresented: $showProLimit) {
            Button("Not Now", role: .cancel) {}
            Button("Upgrade") {
                showPaywall = true
            }
        } message: {
            Text("Please purchase a subscription if you want to continue using this feature and all other Pro features.")
        }
        .sheet(isPresented: $showPaywall) {
        #if !DEBUG
        PaywallView(displayCloseButton: true)
        #endif
        }
    }
    
    private func canCreateNewListing() -> Bool {
        // Allow if user is Pro OR has 0 listings
        return viewModel.isProUser || viewModel.listings.count < 1
    }
    
    func addSongToListing(song: Song, listing: Listing){
        selectedSong = nil
        viewModel.saveListItem(listing, song: song.songId)
        toastMessage = "\(song.title) added to \(listing.title) listing"
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showToast = false
        }
    }
    
    func likeSong(song: Song){
        viewModel.likeSong(song: song)
        toastMessage = L10n.likedSong(for: song.title, isLiked: !song.liked)
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showToast = false
        }
    }
    
    @ViewBuilder
    private var stateContent: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(songs.enumerated()), id: \.element.id) { index, song in
                NavigationLink(destination: PresenterView(song: song, songs: songs)) {
                    SongItem(
                        song: song,
                        height: 50,
                        isSelected: false,
                        isSearching: false
                    )
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button {
                        likeSong(song: song)
                    } label: {
                        Label(
                            song.liked ? "Remove from Likes" : "Add to Likes",
                            systemImage: song.liked ? "heart.fill" : "heart"
                        )
                    }
                    .tint(.primary1)
                }
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    Button {
                        if viewModel.listings.isEmpty && !canCreateNewListing() {
                            showProLimit = true
                        } else {
                            selectedSong = song
                        }
                    } label: {
                        Label("Add to Listing", systemImage: "text.badge.plus")
                    }
                    .tint(.primaryContainer)
                }
                .contextMenu {
                    Button {
                        likeSong(song: song)
                    } label: {
                        Label(
                            song.liked ? "Remove from Likes" : "Add to Likes",
                            systemImage: song.liked ? "heart.fill" : "heart"
                        )
                    }

                    Button {
                        if viewModel.listings.isEmpty && !canCreateNewListing() {
                            showProLimit = true
                        } else {
                            selectedSong = song
                        }
                    } label: {
                        Label("Add to Listing", systemImage: "text.badge.plus")
                    }

                    ShareLink(
                        item: SongUtils.shareText(song: song)
                    ) {
                        Label(
                            "Share this song",
                            systemImage: "square.and.arrow.up"
                        )
                    }
                }

                if index < songs.count - 1 {
                    Divider()
                }
            }
        }
    }
}
