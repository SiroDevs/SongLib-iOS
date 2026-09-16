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
    @Binding var editMode: EditMode
    @Binding var selectedIDs: Set<Int>
    @Binding var isAtTop: Bool
    @Binding var scrollToTopAction: (() -> Void)?

    init(
        viewModel: HomeViewModel,
        songs: [Song],
        editMode: Binding<EditMode>,
        selectedIDs: Binding<Set<Int>>,
        isAtTop: Binding<Bool> = .constant(true),
        scrollToTopAction: Binding<(() -> Void)?> = .constant(nil)
    ) {
        self.viewModel = viewModel
        self.songs = songs
        self._editMode = editMode
        self._selectedIDs = selectedIDs
        self._isAtTop = isAtTop
        self._scrollToTopAction = scrollToTopAction
    }

    @State private var selectedSong: Song?
    @State private var showBatchListingSheet = false

    @State private var showToast = false
    @State private var toastMessage: String = ""
    @State private var showPaywall = false
    @State private var showProLimit = false

    // Sharing a song's words and copying it to Drafts share one PRO
    // usage allowance across every entry point on this screen.
    @StateObject private var songSharingGate = ProFeatureGateModel(feature: .songSharing)
    @State private var pendingShareText: String?
    @State private var showShareSheet = false

    private var isEditing: Bool { editMode == .active }

    private var selectedSongs: [Song] {
        songs.filter { selectedIDs.contains($0.id) }
    }

    // Only feed List a live selection binding while actually editing.
    // Otherwise, tapping a NavigationLink row to browse would also mark
    // that row as "selected", leaving it highlighted when you pop back.
    private var rowSelection: Binding<Set<Int>> {
        Binding(
            get: { isEditing ? selectedIDs : [] },
            set: { newValue in if isEditing { selectedIDs = newValue } }
        )
    }

    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                List(selection: rowSelection) {
                    ForEach(Array(songs.enumerated()), id: \.element.id) { index, song in
                        NavigationLink(destination: PresenterView(song: song, songs: songs)) {
                            SongItem(
                                song: song,
                                height: 50,
                                isSelected: false,//selectedIDs.contains(song.id),
                                isSearching: false
                            )
                        }
                        .id(index == 0 ? "top" : nil)
                        .onAppear {
                            if index == 0 { isAtTop = true }
                        }
                        .onDisappear {
                            if index == 0 { isAtTop = false }
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparatorTint(Color("outline").opacity(0.2))
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button {
                                likeSong(song: song)
                            } label: {
                                Label(
                                    song.liked ? "Unlike" : "Like",
                                    systemImage: song.liked ? "heart.slash" : "heart.fill"
                                )
                            }
                            .tint(.primary1)

                            Button {
                                songSharingGate.attemptUse {
                                    shareSong(song)
                                }
                            } label: {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                            .tint(.primaryContainer)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                songSharingGate.attemptUse {
                                    copyToDrafts(song: song)
                                }
                            } label: {
                                Label("Copy", systemImage: "doc.on.doc")
                            }
                            .tint(.secondary1)

                            Button {
                                if viewModel.listings.isEmpty && !canCreateNewListing() {
                                    showProLimit = true
                                } else {
                                    selectedSong = song
                                }
                            } label: {
                                Label("List", systemImage: "text.badge.plus")
                            }
                            .tint(.primaryContainer)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .environment(\.editMode, $editMode)
                .onAppear {
                    scrollToTopAction = {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            proxy.scrollTo("top", anchor: .top)
                        }
                    }
                }
            }

            if showToast {
                ToastView(message: toastMessage)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .toolbar {
            if isEditing {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        likeSelection()
                    } label: {
                        Label("Like", systemImage: "heart.fill")
                    }
                    .disabled(selectedIDs.isEmpty)

                    Spacer()

                    Button {
                        guard let text = singleSelectionShareText else { return }
                        songSharingGate.attemptUse {
                            pendingShareText = text
                            showShareSheet = true
                        }
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    .disabled(selectedIDs.count != 1)

                    Spacer()

                    Button {
                        if viewModel.listings.isEmpty && !canCreateNewListing() {
                            showProLimit = true
                        } else {
                            showBatchListingSheet = true
                        }
                    } label: {
                        Label("List", systemImage: "text.badge.plus")
                    }
                    .disabled(selectedIDs.isEmpty)
                }
            }
        }
        .sheet(item: $selectedSong) { song in
            ChooseListingSheet(
                listings: viewModel.listings,
                onSelect: { listing in
                    addSongToListing(song: song, listing: listing)
                },
                onNewList: { title in
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
        .sheet(isPresented: $showBatchListingSheet) {
            ChooseListingSheet(
                listings: viewModel.listings,
                onSelect: { listing in
                    addSelectionToListing(listing)
                },
                onNewList: { title in
                    if canCreateNewListing() {
                        viewModel.saveListing(0, title: title)
                        if let newListing = viewModel.listings.last {
                            addSelectionToListing(newListing)
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
        .sheet(isPresented: $showShareSheet) {
            if let pendingShareText {
                ShareSheet(items: [pendingShareText])
            }
        }
        .proFeatureAlerts(songSharingGate) { showPaywall = true }
    }

    private var singleSelectionShareText: String? {
        guard selectedIDs.count == 1, let song = selectedSongs.first else { return nil }
        return SongUtils.shareText(song: song)
    }

    private func canCreateNewListing() -> Bool {
        return viewModel.isProUser || viewModel.listings.count < 1
    }

    func addSongToListing(song: Song, listing: Listing) {
        selectedSong = nil
        viewModel.saveListItem(listing, song: song.songId)
        showToastMessage("\(song.title) added to \(listing.title) listing")
    }

    private func addSelectionToListing(_ listing: Listing) {
        for song in selectedSongs {
            viewModel.saveListItem(listing, song: song.songId)
        }
        showBatchListingSheet = false
        let count = selectedSongs.count
        showToastMessage("\(count) \(count == 1 ? "song" : "songs") added to \(listing.title)")
        selectedIDs.removeAll()
    }

    func likeSong(song: Song) {
        viewModel.likeSong(song: song)
        showToastMessage(L10n.likedSong(for: song.title, isLiked: !song.liked))
    }

    private func likeSelection() {
        let songsToLike = selectedSongs
        guard !songsToLike.isEmpty else { return }
        viewModel.likeSongs(songsToLike)
        showToastMessage("Updated likes for \(songsToLike.count) \(songsToLike.count == 1 ? "song" : "songs")")
        selectedIDs.removeAll()
    }

    private func copyToDrafts(song: Song) {
        viewModel.copyToDrafts(song: song)
        showToastMessage("Copied \"\(song.title)\" to Drafts")
    }

    private func shareSong(_ song: Song) {
        pendingShareText = SongUtils.shareText(song: song)
        showShareSheet = true
    }

    private func showToastMessage(_ message: String) {
        toastMessage = message
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showToast = false
        }
    }
}
