//
//  HomeLikes.swift
//  SongLib
//
//  Created by Siro Daves on 25/08/2025.
//

import SwiftUI

struct HomeLikes: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.likes.isEmpty {
                    EmptyState(
                        message: L10n.emptySongLikes,
                        messageIcon: Image(systemName: "heart.fill")
                    )
                } else {
                    ScrollView {
                        VStack(spacing: 1) {
                            BooksList(
                                books: viewModel.books,
                                selectedBook: viewModel.selectedBook,
                                onSelect: { book in
                                    viewModel.selectedBook = viewModel.books.firstIndex(of: book) ?? 0
                                    viewModel.filterSongs(book: book.bookId)
                                }
                            )

                            Spacer()
                            SongsList(
                                viewModel: viewModel,
                                songs: viewModel.likes,
                            )
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Liked Songs")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.regularMaterial, for: .navigationBar)
            .homeToolbar(viewModel: viewModel, actions: .more)
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
