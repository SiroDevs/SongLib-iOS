//
//  ListingContent.swift
//  SongLib
//
//  Created by Siro Daves on 30/08/2025.
//

import SwiftUI

struct ListingContent: View {
    @ObservedObject var viewModel: ListingViewModel
    let songs: [Song]
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
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
                    }
    //                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
    //                    Button {
    ////                        viewModel.likeSong(song)
    //                    } label: {
    //                        Label("Like", systemImage: "heart.fill")
    //                    }
    //                    .tint(.pink)
    //
    //                    Button {
    ////                        viewModel.deleteListing(song.id)
    //                    } label: {
    //                        Label("Delete", systemImage: "trash.fill")
    //                    }
    //                    .tint(.red)
    //                }
    //                .swipeActions(edge: .leading, allowsFullSwipe: false) {
    //                    Button {
    ////                        viewModel.addToQueue(song)
    //                    } label: {
    //                        Label("Queue", systemImage: "text.line.first.and.arrowtriangle.forward")
    //                    }
    //                    .tint(.blue)
    //                }

                    if index < songs.count - 1 {
                        Divider()
                    }
                }
            }
        }
    }
}
