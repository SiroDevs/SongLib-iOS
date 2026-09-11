//
//  HomeSearch.swift
//  SongLib
//
//  Created by Siro Daves on 04/05/2025.
//

import SwiftUI

struct HomeSearch: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var searchQry: String = ""
    @State private var searchByNo: Bool = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 1) {
                        SongsSearchBar(text: $searchQry, onCancel: {
                            searchQry = ""
                            viewModel.searchSongs(qry: "")
                        })
                        .onChange(of: searchQry) { newValue in
                            viewModel.searchSongs(qry: newValue, byNo: searchByNo)
                        }

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
                            songs: viewModel.filtered,
                        )
                    }
                    .padding(.vertical)
                }
                
                if viewModel.isProUser {
                    Button {
                        searchByNo = true
                        searchQry = ""
                        viewModel.searchSongs(qry: "", byNo: true)
                    } label: {
                        Image(systemName: "circle.grid.3x3.fill")
                            .font(.title.weight(.semibold))
                            .padding()
                            .foregroundColor(.onPrimaryContainer)
                            .background(.primaryContainer)
                            .clipShape(Circle())
                            .shadow(radius: 4, x: 0, y: 4)
                    }
                    .padding()
                    
                    if searchByNo {
                        DialPad(
                            onNumberClick: { num in
                                searchQry += num
                                viewModel.searchSongs(qry: searchQry, byNo: true)
                            },
                            onBackspaceClick: {
                                if !searchQry.isEmpty {
                                    searchQry.removeLast()
                                    viewModel.searchSongs(qry: searchQry, byNo: true)
                                }
                            },
                            onSearchClick: {
                                viewModel.searchSongs(qry: searchQry, byNo: true)
                                searchByNo = false
                            }
                        )
                        .animation(.easeInOut, value: true)
                    }
                }
            }
            .navigationTitle("SongLib")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.regularMaterial, for: .navigationBar)
            .homeToolbar(viewModel: viewModel, actions: [.drafts, .more])
        }
    }
}

struct HomeSearchMock: View {
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
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
                .navigationTitle("SongLib")
                .toolbarBackground(.regularMaterial, for: .navigationBar)
                
                Button {
                } label: {
                    Image(systemName: "circle.grid.3x3.fill")
                        .font(.title.weight(.semibold))
                        .padding()
                        .foregroundColor(.onPrimaryContainer)
                        .background(.primaryContainer)
                        .clipShape(Circle())
                        .shadow(radius: 4, x: 0, y: 4)
                }
                .padding()
                DialPad(
                    onNumberClick: { num in
                    },
                    onBackspaceClick: {
                    },
                    onSearchClick: {
                    }
                )
            }
        }
    }
}

#Preview {
    HomeSearchMock()
}
