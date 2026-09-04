//
//  HomeViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation
import SwiftUI

final class MainViewModel: ObservableObject {
    private let prefsRepo: PrefsRepo
    private let songbkRepo: SongBookRepoProtocol
    private let listingRepo: ListingRepoProtocol
    private let reviewRepo: ReviewReqRepoProtocol
    private let subsRepo: SubsRepoProtocol
    
    @Published var isProUser: Bool = false
    @Published var horizontalSlides: Bool = false
    @Published var showReviewPrompt: Bool = false
    
    @Published var books: [Book] = []
    @Published var songs: [Song] = []
    @Published var likes: [Song] = []
    @Published var filtered: [Song] = []
    @Published var listings: [Listing] = []
    @Published var selectedBook: Int = 0
    @Published var uiState: UiState = .idle

    init(
        prefsRepo: PrefsRepo,
        songbkRepo: SongBookRepoProtocol,
        listingRepo: ListingRepoProtocol,
        reviewRepo: ReviewReqRepoProtocol,
        subsRepo: SubsRepoProtocol
    ) {
        self.prefsRepo = prefsRepo
        self.songbkRepo = songbkRepo
        self.listingRepo = listingRepo
        self.reviewRepo = reviewRepo
        self.subsRepo = subsRepo
    }
    
    private func validateSubscription(isOnline: Bool) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            subsRepo.isProUser(isOnline: isOnline) { isActive in
                Task { @MainActor in
                    self.isProUser = isActive
                    continuation.resume()
                }
            }
        }
    }
    
    func appDidEnterBackground() {
        reviewRepo.endSession()
        showReviewPrompt = reviewRepo.shouldPromptReview()
    }
    
    func appDidBecomeActive() {
        reviewRepo.startSession()
    }
    
    func promptReview() {
        reviewRepo.promptReview(force: true)
    }
    
    func updateSlides(value: Bool) {
        prefsRepo.horizontalSlides = value
        horizontalSlides = value
    }
    
    func fetchData() {
        uiState = .loading("")
        Task { @MainActor in
            try await validateSubscription(isOnline: false)
            horizontalSlides = prefsRepo.horizontalSlides
            books = songbkRepo.fetchLocalBooks()
            songs = songbkRepo.fetchLocalSongs()
            listings = listingRepo.fetchListings(for: 0)
            uiState = .fetched
        }
    }
    
    func filterSongs(book: Int) {
        Task {
            await MainActor.run {
                filtered = songs.filter { $0.book == book }
                likes = songs.filter { $0.liked }
                uiState = .filtered
            }
        }
    }
    
    func searchSongs(qry: String, byNo: Bool = false) {
        filtered = SongUtils.searchSongs(songs: songs, qry: qry, byNo: byNo)
        self.uiState = .filtered
    }
    
    func likeSong(song: Song) {
        songbkRepo.likeSong(song)
        uiState = .filtered
    }
    
    func saveListing(_ parent: Int, title: String) {
        listingRepo.saveListing(parent, title: title)
        Task { @MainActor in
            listings = listingRepo.fetchListings(for: 0)
            uiState = .filtered
        }
    }
    
    func saveListItem(_ listing: Listing, song: Int) {
        listingRepo.saveListItem(listing, song: song)
        Task { @MainActor in
            listings = listingRepo.fetchListings(for: 0)
            uiState = .filtered
        }
    }
    
    func deleteListing(_ listing: Int) {
        listingRepo.deleteListing(with: listing)
        Task { @MainActor in
            listings = listingRepo.fetchListings(for: 0)
            uiState = .filtered
        }
    }
    
    func clearAllData() {
        print("Clearing data")
        uiState = .loading("Clearing data ...")
        Task { @MainActor in
            songbkRepo.deleteLocalData()
            listingRepo.deleteListings()
            prefsRepo.resetPrefs()
            uiState = .loaded
        }
    }
}
