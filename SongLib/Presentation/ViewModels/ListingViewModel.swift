//
//  ListingViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 06/05/2025.
//

import Foundation
import SwiftUI

final class ListingViewModel: ObservableObject {
    private let netUtils: NetworkUtils
    private let prefsRepo: PreferencesRepository
    private let songbkRepo: SongBookRepositoryProtocol
    private let listRepo: ListingRepositoryProtocol
    private let subsRepo: SubscriptionRepositoryProtocol

    @Published var uiState: UiState = .idle
    @Published var title: String = ""
    @Published var hasChorus: Bool = false
    @Published var indicators: [String] = []
    @Published var verses: [String] = []
    
    @Published var songs: [Song] = []
    @Published var listedSongs: [Song] = []
    @Published var listings: [Listing] = []
    @Published var listItems: [Listing] = []
    
    @Published var isLiked: Bool = false
    @Published var isProUser: Bool = false
    @Published var listingTitle: String = "Untitled List"

    init(
        netUtils: NetworkUtils = .shared,
        prefsRepo: PreferencesRepository,
        songbkRepo: SongBookRepositoryProtocol,
        listRepo: ListingRepositoryProtocol,
        subsRepo: SubscriptionRepositoryProtocol
    ) {
        self.netUtils = netUtils
        self.prefsRepo = prefsRepo
        self.songbkRepo = songbkRepo
        self.listRepo = listRepo
        self.subsRepo = subsRepo
    }
    
    func checkSubscription() async {
        let isOnline = await netUtils.checkNetworkAvailability()
        subsRepo.isProUser(isOnline: isOnline) { [weak self] isActive in
            Task { @MainActor in
                self?.isProUser = isActive
            }
        }
    }
    
    func loadListing(listing: Listing) {
        uiState = .loading("")
        
        Task {
            await MainActor.run {
                listItems = listRepo.fetchListings(for: listing.id)
                listingTitle = listing.title
                listedSongs.removeAll()
                for item in listItems {
                    if let song = songbkRepo.fetchSong(withId: item.song) {
                        listedSongs.append(song)
                    } else {
                        print("⚠️ Missing song \(item.song)")
                    }
                }
                isProUser = prefsRepo.isProUser
                uiState = .loaded
            }
        }
    }

    func loadSong(song: Song) {
        uiState = .loading("Loading ...")
        
        indicators = []
        verses = []

        hasChorus = song.content.contains("CHORUS")
        title = SongUtils.songItemTitle(number: song.songNo, title: song.title)

        let songVerses = SongUtils.getSongVerses(songContent: song.content)
        let verseCount = songVerses.count

        if hasChorus {
            let chorus = songVerses[1].replacingOccurrences(of: "CHORUS#", with: "")

            indicators.append("1")
            indicators.append("C")
            verses.append(songVerses[0])
            verses.append(chorus)

            for i in 2..<verseCount {
                indicators.append("\(i)")
                indicators.append("C")
                verses.append(songVerses[i])
                verses.append(chorus)
            }
        } else {
            for i in 0..<verseCount {
                indicators.append("\(i + 1)")
                verses.append(songVerses[i])
            }
        }
        
        isLiked = song.liked
        uiState = .loaded
    }
    
    func likeSong(song: Song) {
        songbkRepo.likeSong(song)
        isLiked = !song.liked
        uiState = .liked
    }
    
    func saveListing(_ parent: Int, song: Int, title: String) {
        listRepo.saveListing(parent, title: title)
        Task { @MainActor in
            listItems = listRepo.fetchListings(for: parent)
            listings = listRepo.fetchListings(for: 0)
            uiState = .loaded
        }
    }
    
    func updateListing(_ parent: Listing, title: String) {
        listRepo.updateListing(parent, title: title)
        listingTitle = title
        Task { @MainActor in
            listItems = listRepo.fetchListings(for: parent.id)
            listings = listRepo.fetchListings(for: 0)
            uiState = .loaded
        }
    }
    
    func saveListItem(_ listing: Listing, song: Int) {
        listRepo.saveListItem(listing, song: song)
        Task { @MainActor in
            listItems = listRepo.fetchListings(for: listing.id)
            listings = listRepo.fetchListings(for: 0)
            uiState = .loaded
        }
    }
    
    func deleteListing(_ listing: Int, parent: Int) {
        listRepo.deleteListing(with: listing)
        Task { @MainActor in
            if parent != 0 {
                listItems = listRepo.fetchListings(for: parent)
            }
            listings = listRepo.fetchListings(for: 0)
            uiState = .loaded
        }
    }
    
}
