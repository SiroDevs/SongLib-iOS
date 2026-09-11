//
//  PresenterContent.swift
//  SongLib
//
//  Created by Siro Daves on 26/08/2025.
//

import SwiftUI
import SwiftUIPager
import RevenueCatUI

struct PresenterContent: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ListingViewModel
    @ObservedObject var selected: Page
    let song: Song
    var onToast: (String) -> Void = { _ in }

    @State private var showListingSheet = false
    @State private var showNewListingAlert = false
    @State private var newListingTitle = ""
    @State private var showProLimit = false
    @State private var showPaywall = false

    /// The song actually on screen - after navigating with the corner
    /// arrows this is no longer necessarily `song`, the one the presenter
    /// was originally opened with.
    private var activeSong: Song {
        viewModel.currentSong ?? song
    }

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                PresenterTabs(
                    verses: viewModel.verses,
                    indicators: viewModel.indicators,
                    songTitle: viewModel.title,
                    selected: selected,
                    hasPreviousSong: viewModel.hasPrevious,
                    hasNextSong: viewModel.hasNext,
                    onPreviousSong: navigatePrevious,
                    onNextSong: navigateNext
                )
                .frame(maxHeight: .infinity)

                PresenterIndicators(
                    indicators: viewModel.indicators,
                    selected: selected
                )
                .fixedSize(horizontal: false, vertical: true)
            }

            // Floating share button, in place of the old top-bar share
            // icon - same spot/role as Android's presenter FAB.
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ShareLink(item: SongUtils.shareText(song: activeSong)) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.onPrimaryContainer)
                            .frame(width: 52, height: 52)
                            .background(Color.primaryContainer)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.18), radius: 6, x: 0, y: 4)
                    }
                    .padding(.trailing, 20)
                }
                .padding(.bottom, 78)
            }
        }
        .background(.surface)
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: { Image(systemName: "chevron.backward") }
            }

            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    viewModel.likeSong(song: activeSong)
                } label: {
                    Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                        .foregroundColor(.primary1)
                }

                Menu {
                    Button {
                        viewModel.copyToDrafts(song: activeSong)
                        onToast("Copied \"\(activeSong.title)\" to Drafts")
                    } label: {
                        Label("Copy to Drafts", systemImage: "doc.on.doc")
                    }

                    Button {
                        if viewModel.listings.isEmpty && !canCreateNewListing() {
                            showProLimit = true
                        } else {
                            showListingSheet = true
                        }
                    } label: {
                        Label("Add to a List", systemImage: "text.badge.plus")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.primary1)
                }
            }
        }
        .task {
            viewModel.fetchListings()
        }
        .sheet(isPresented: $showListingSheet) {
            ChooseListingSheet(
                listings: viewModel.listings,
                onSelect: { listing in
                    showListingSheet = false
                    viewModel.saveListItem(listing, song: activeSong.songId)
                    onToast("Added \"\(activeSong.title)\" to \(listing.title)")
                },
                onNewList: { title in
                    if canCreateNewListing() {
                        viewModel.saveListing(0, song: activeSong.songId, title: title)
                        showListingSheet = false
                        onToast("Added \"\(activeSong.title)\" to \(title)")
                    } else {
                        showProLimit = true
                    }
                }
            )
        }
        .alert("Support us by upgrading", isPresented: $showProLimit) {
            Button("Not Now", role: .cancel) {}
            Button("Upgrade") { showPaywall = true }
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
        viewModel.isProUser || viewModel.listings.count < 1
    }

    private func navigatePrevious() {
        viewModel.navigateToPrevious()
        selected.update(.new(index: 0))
    }

    private func navigateNext() {
        viewModel.navigateToNext()
        selected.update(.new(index: 0))
    }
}
