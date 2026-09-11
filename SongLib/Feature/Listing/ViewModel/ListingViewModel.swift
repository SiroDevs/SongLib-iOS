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
    private let prefsRepo: PrefsRepo
    private let songbkRepo: SongBookRepoProtocol
    private let listRepo: ListingRepoProtocol
    private let subsRepo: SubsRepoProtocol
    private let draftRepo: DraftRepoProtocol

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

    /// The songs surrounding whatever's currently loaded in the presenter
    /// (e.g. the search results the user tapped a song from), plus where
    /// in that list we currently are - powers the previous/next song
    /// corner navigation.
    @Published var contextSongs: [Song] = []
    @Published var currentIndex: Int = 0

    var hasPrevious: Bool { currentIndex > 0 }
    var hasNext: Bool { currentIndex < contextSongs.count - 1 }
    var currentSong: Song? {
        contextSongs.indices.contains(currentIndex) ? contextSongs[currentIndex] : nil
    }

    init(
        netUtils: NetworkUtils = .shared,
        prefsRepo: PrefsRepo,
        songbkRepo: SongBookRepoProtocol,
        listRepo: ListingRepoProtocol,
        subsRepo: SubsRepoProtocol,
        draftRepo: DraftRepoProtocol
    ) {
        self.netUtils = netUtils
        self.prefsRepo = prefsRepo
        self.songbkRepo = songbkRepo
        self.listRepo = listRepo
        self.subsRepo = subsRepo
        self.draftRepo = draftRepo
    }
    
    func validateSubscription() async {
        let isOnline = await netUtils.checkNetworkAvailability()
        subsRepo.isProUser(isOnline: isOnline) { [weak self] isActive in
            Task { @MainActor in
                self?.isProUser = isActive
            }
        }
    }
    
    func loadListing(listing: Listing) {
        uiState = .loading("")
        
        Task { @MainActor in
            await validateSubscription()
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
            uiState = .loaded
        }
    }

    /// - Parameter context: the list `song` was tapped from (search
    ///   results, likes, a listing, ...). Pass it whenever you have it so
    ///   the presenter can offer previous/next song navigation; leave it
    ///   empty for a one-off load (e.g. re-loading after an error) and the
    ///   existing context is left untouched.
    func loadSong(song: Song, context: [Song] = []) {
        if !context.isEmpty {
            contextSongs = context
            currentIndex = context.firstIndex(where: { $0.id == song.id }) ?? 0
        }

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

    /// Moves to the previous song in `contextSongs`, if any, reloading the
    /// presenter with it.
    func navigateToPrevious() {
        guard hasPrevious else { return }
        currentIndex -= 1
        loadSong(song: contextSongs[currentIndex])
    }

    /// Moves to the next song in `contextSongs`, if any, reloading the
    /// presenter with it.
    func navigateToNext() {
        guard hasNext else { return }
        currentIndex += 1
        loadSong(song: contextSongs[currentIndex])
    }
    
    func likeSong(song: Song) {
        songbkRepo.likeSong(song)
        isLiked = !song.liked
        uiState = .liked
    }

    /// Fetches the top-level listings so the "Add to a List" sheet has
    /// something to show.
    func fetchListings() {
        listings = listRepo.fetchListings(for: 0)
    }

    /// Copies a song into Drafts so it can be freely edited, mirroring
    /// Android's `DraftController.copyToDrafts`.
    func copyToDrafts(song: Song) {
        draftRepo.saveDraft(
            title: SongUtils.songItemTitle(number: song.songNo, title: song.title),
            content: song.content,
            songNo: song.songNo,
            book: song.book
        )
    }
    
    func saveListing(_ parent: Int, song: Int, title: String) {
        listRepo.saveListing(parent, title: title)
        Task { @MainActor in
            listings = listRepo.fetchListings(for: 0)
            // `saveListing` only creates the listing itself; attach the
            // song to it as a second step, same as the manual
            // create-then-attach flow SongsList already does.
            if song != 0, let newListing = listings.first(where: { $0.title == title }) ?? listings.last {
                listRepo.saveListItem(newListing, song: song)
            }
            listItems = listRepo.fetchListings(for: parent)
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
