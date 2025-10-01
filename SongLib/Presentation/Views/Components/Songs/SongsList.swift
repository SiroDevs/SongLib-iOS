//
//  SongsList.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import SwiftUI

struct SongsList: View {
    @ObservedObject var viewModel: MainViewModel
    let songs: [Song]

    @State private var selectedSong: Song?
    @State private var showToast = false
    @State private var toastMessage: String = ""
    
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
                    viewModel.saveListing(0, title: title)
                    if let newListing = viewModel.listings.last {
                        addSongToListing(song: song, listing: newListing)
                    }
                }
            )
        }
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
                NavigationLink(destination: PresenterView(song: song)) {
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
                        selectedSong = song
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
                        selectedSong = song
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
