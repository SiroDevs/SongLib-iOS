//
//  HomeTabsMocks.swift
//  SongLib
//
//  Created by Siro Daves on 28/08/2025.
//

import SwiftUI

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

struct HomeListingsMock: View {
    @State private var showNewListingAlert = false
    @State private var newListingTitle = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(Listing.sampleListings.indices, id: \.self) { index in
                    let listing = Listing.sampleListings[index]

                    VStack(spacing: 0) {
                        NavigationLink {
                            ListingView(listing: listing)
                        } label: {
                            ListingItem(listing: listing)
                        }

                        if index < Listing.sampleListings.count - 1 {
                            Divider()
                        }
                    }
                }
                .background(.surface)
                .padding(.vertical)
            }
            .navigationTitle("Song Listings")
            .toolbarBackground(.regularMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showNewListingAlert = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("New Listing", isPresented: $showNewListingAlert) {
                TextField("Listing title", text: $newListingTitle)
                Button("Add", action: {
                    guard !newListingTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    newListingTitle = ""
                })
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Enter a title for your new song listing")
            }
        }
    }
}

#Preview {
    HomeSearchMock()
}
