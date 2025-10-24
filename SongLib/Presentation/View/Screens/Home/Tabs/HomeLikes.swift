//
//  HomeLikes.swift
//  SongLib
//
//  Created by Siro Daves on 25/08/2025.
//

import SwiftUI

struct HomeLikes: View {
    @ObservedObject var viewModel: MainViewModel

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
                        .background(.surface)
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Liked Songs")
            .toolbarBackground(.regularMaterial, for: .navigationBar)
        }
    }
}
