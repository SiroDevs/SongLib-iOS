//
//  ListingItem.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import SwiftUI

struct ListingItem: View {
    let listing: Listing

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(listing.title)
                .font(.title3)
                .foregroundColor(.scrim)
                .fontWeight(.bold)
                .lineLimit(1)

            HStack {
                Text("\(listing.songCount) \(listing.songCount == 1 ? "song" : "songs")")
                    .font(.subheadline)
                    .foregroundColor(.scrim)

                Spacer()

                Text("updated \(listing.lastUpdate)")
                    .font(.subheadline)
                    .foregroundColor(.scrim)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .contentShape(Rectangle())
    }
}
