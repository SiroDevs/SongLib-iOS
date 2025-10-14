//
//  Step1ViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation
import SwiftUI

final class SelectionViewModel: ObservableObject {
    @Published var books: [Selectable<Book>] = []
    @Published var songs: [Song] = []
    @Published var uiState: UiState = .idle
    
    @Published var progress: Int = 0

    private let prefsRepo: PreferencesRepository
    private let songbkRepo: SongBookRepositoryProtocol

    init(
        prefsRepo: PreferencesRepository,
        songbkRepo: SongBookRepositoryProtocol
    ) {
        self.prefsRepo = prefsRepo
        self.songbkRepo = songbkRepo
    }
    
    func toggleSelection(for book: Book) {
        guard let index = books.firstIndex(where: { $0.data.id == book.id }) else { return }
        books[index].isSelected.toggle()
    }

    func selectedBooks() -> [Book] {
        books.filter { $0.isSelected }.map { $0.data }
    }

    func selectedBooksIds() -> String {
        books
            .filter { $0.isSelected }
            .map { "\($0.data.bookNo)" }
            .joined(separator: ",")
    }

    func fetchBooks() {
        uiState = .loading("Fetching books ...")

        Task {
            do {
                let resp: [Book] = try await songbkRepo.fetchRemoteBooks()
                let data = resp.map { Selectable(data: $0, isSelected: false) }
                await MainActor.run {
                    self.books = data
                    self.uiState = .fetched
                }
            } catch {
                await MainActor.run {
                    self.uiState = .error("Failed to fetch books: \(error.localizedDescription)")
                }
            }
        }
    }

    func saveBooks() {
        uiState = .saving("Saving books ...")
        print("Selected books: \(selectedBooks())")
                
        Task {
            self.songbkRepo.saveBooks(selectedBooks())
            
            await MainActor.run {
                self.prefsRepo.isDataSelected = true
                self.prefsRepo.selectedBooks = selectedBooksIds()
                self.uiState = .saved
            }
        }
    }
    
    func fetchSongs() {
        uiState = .loading("Fetching songs ...")

        Task {
            do {
                let resp: [Song] = try await songbkRepo.fetchRemoteSongs(for: prefsRepo.selectedBooks)
                await MainActor.run {
                    self.songs = resp
                    self.uiState = .fetched
                }
            } catch {
                await MainActor.run {
                    self.uiState = .error("Failed to fetch songs: \(error)")
                }
            }
        }
    }

    func initializeStep2() {
        Task {
            await fetchAndSaveSongs()
        }
    }

    func fetchAndSaveSongs() async {
        await MainActor.run {
            self.uiState = .loading("Fetching Songs ...")
            self.progress = 0
        }

        do {
            let fetchedSongs = try await songbkRepo.fetchRemoteSongs(for: prefsRepo.selectedBooks)

            await MainActor.run {
                self.songs = fetchedSongs

                self.uiState = .saving("Saving songs ...")
                self.progress = 0
            }

            try await saveSongs()

            prefsRepo.isDataLoaded = true

            await MainActor.run {
                self.uiState = .saved
            }

            print("✅ Songs fetched and saved successfully.")
        } catch {
            await MainActor.run {
                self.uiState = .error("Failed: \(error.localizedDescription)")
            }
            print("❌ Initialization failed: \(error)")
        }
    }
    
    
    private func saveSongs() async throws {
        print("Now saving songs")
        await MainActor.run {
            self.progress = 0
            self.uiState = .saving("Saving \(songs.count) songs")
        }

        for (index, song) in songs.enumerated() {
            songbkRepo.saveSong(song)
            await MainActor.run {
                self.updateProgress(current: index + 1, total: songs.count)
            }
        }
        print("✅ Songs saved successfully")
    }
    
    @MainActor
    private func updateProgress(current: Int, total: Int) {
        guard total > 0 else { return }
        let newProgress = Int((Double(current) / Double(total)) * 100)
        if newProgress > progress {
            self.progress = newProgress
        }
    }
}
