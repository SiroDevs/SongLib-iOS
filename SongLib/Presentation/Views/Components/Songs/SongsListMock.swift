//
//  SongsListMock.swift
//  SongLib
//
//  Created by Siro Daves on 28/08/2025.
//

import SwiftUI

struct SongsListMock: View {
    let songs: [Song]
    @State private var selectedSong: Song?
    @State private var showListingSheet = false
    
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(songs.enumerated()), id: \.element.id) { index, song in
                NavigationLink {
                    PresenterView(song: song)
                } label: {
                    SongItem(
                        song: song,
                        height: 50,
                        isSelected: false,
                        isSearching: false
                    )
                    .contextMenu {
                        Button { } label: {
                            Label(
                                "Add to Likes",
                                systemImage: "heart.fill",
                            )
                        }
                        Button {
                            selectedSong = song
                            showListingSheet = true
                        } label: {
                            Label("Add to Listing", systemImage: "text.badge.plus")
                        }
                        
                        ShareLink(
                            item: SongUtils.shareText(song: song),
                        ) {
                            Label(
                                "Share this song",
                                systemImage: "square.and.arrow.up",
                            )
                        }
                    }
                }
                if index < songs.count - 1 { Divider() }
            }
        }
        .sheet(isPresented: $showListingSheet) {
            ChooseListingSheet(
                listings: Listing.sampleListings,
                onSelect: { listing in },
                onNewList: { title in
                    showListingSheet = false
                }
            )
        }
    }
}

#Preview {
    SongsListMock(songs: Song.sampleSongs)
}
