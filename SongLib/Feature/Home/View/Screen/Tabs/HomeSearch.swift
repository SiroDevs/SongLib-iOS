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

    @State private var editMode: EditMode = .inactive
    @State private var selectedIDs: Set<Int> = []

    @State private var isAtTop: Bool = true
    @State private var scrollToTop: (() -> Void)?

    private var isEditing: Bool { editMode == .active }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
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
                            guard let book else {
                                viewModel.selectedBook = -1
                                viewModel.showAllSongs()
                                return
                            }
                            viewModel.selectedBook = viewModel.books.firstIndex(of: book) ?? 0
                            viewModel.filterSongs(book: book.bookId)
                        }
                    )

                    SongsList(
                        viewModel: viewModel,
                        songs: viewModel.filtered,
                        editMode: $editMode,
                        selectedIDs: $selectedIDs,
                        isAtTop: $isAtTop,
                        scrollToTopAction: $scrollToTop
                    )
                }

                if viewModel.isProUser && !isEditing {
                    VStack(alignment: .trailing, spacing: 10) {
                        if !isAtTop {
                            ScrollToTopButton {
                                scrollToTop?()
                            }
                            .transition(.opacity)
                        }

                        SearchByNoFAB(
                            onClick: {
                                searchByNo = true
                                searchQry = ""
                                viewModel.searchSongs(qry: "", byNo: true)
                            },
                            expanded: isAtTop
                        )
                    }
                    .animation(.easeInOut(duration: 0.2), value: isAtTop)
                    .padding()
                }
            }
            .navigationTitle(isEditing ? "\(selectedIDs.count) selected" : "SongLib")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.regularMaterial, for: .navigationBar)
            .toolbar {
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
            .toolbar(isEditing ? .hidden : .visible, for: .tabBar)
            .homeToolbar(viewModel: viewModel, actions: isEditing ? [] : [.drafts, .more])
            .sheet(isPresented: $searchByNo) {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Text("Enter song number")
                            .font(.title)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .overlay(alignment: .trailing) {
                        Button {
                            searchByNo = false
                        } label: {
                            Image(systemName: "xmark")
                                .font(.body.weight(.semibold))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 15)
                    .padding(.bottom, 40)

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
                        },
                    )
                }
                .presentationDetents([.height(430)])
                .presentationDragIndicator(.visible)
            }
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
