//
//  HomeLikes.swift
//  SongLib
//
//  Created by Siro Daves on 25/08/2025.
//

import SwiftUI

struct HomeLikes: View {
    @ObservedObject var viewModel: HomeViewModel

    @State private var editMode: EditMode = .inactive
    @State private var selectedIDs: Set<Int> = []

    private var isEditing: Bool { editMode == .active }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.likes.isEmpty {
                    EmptyState(
                        message: L10n.emptySongLikes,
                        messageIcon: Image(systemName: "heart.fill")
                    )
                } else {
                    VStack(spacing: 1) {
                        BooksList(
                            books: viewModel.books,
                            selectedBook: viewModel.selectedBook,
                            onSelect: { book in
                                viewModel.selectedBook = viewModel.books.firstIndex(of: book) ?? 0
                                viewModel.filterSongs(book: book.bookId)
                            }
                        )

                        SongsList(
                            viewModel: viewModel,
                            songs: viewModel.likes,
                            editMode: $editMode,
                            selectedIDs: $selectedIDs
                        )
                    }
                }
            }
            .navigationTitle(isEditing ? "\(selectedIDs.count) selected" : "Liked Songs")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.regularMaterial, for: .navigationBar)
            .toolbar {
                if !viewModel.likes.isEmpty {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(isEditing ? "Done" : "Edit") {
                            withAnimation {
                                editMode = isEditing ? .inactive : .active
                                if !isEditing {
                                    selectedIDs.removeAll()
                                }
                            }
                        }
                    }
                }
            }
            .toolbar(isEditing ? .hidden : .visible, for: .tabBar)
            .homeToolbar(viewModel: viewModel, actions: isEditing ? [] : .more)
        }
    }
}

struct HomeLikesMock: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 1) {
                    BooksList(
                        books: Book.sampleBooks,
                        selectedBook: 0,
                        onSelect: { book in }
                    )
                    
                    Spacer()
                    SongsListMock(
                        songs: Song.sampleSongs,
                    )
                }
                .background(.surface)
                .padding(.vertical)
            }
            .navigationTitle("Liked Songs")
            .toolbarBackground(.regularMaterial, for: .navigationBar)
        }
    }
}
