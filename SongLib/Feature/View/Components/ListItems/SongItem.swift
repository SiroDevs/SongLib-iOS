//
//  SongItem.swift
//  SongLib
//
//  Created by Siro Daves on 04/05/2025.
//

import SwiftUI

struct SongItem: View {
    let song: Song
    let height: CGFloat
    let isSelected: Bool
    let isSearching: Bool

    private var verses: [String] {
        song.content.components(separatedBy: "##")
    }

    private var hasChorus: Bool {
        song.content.contains("CHORUS")
    }

    private var chorusText: String {
        hasChorus ? "Chorus" : ""
    }

    private var versesText: String {
        let count = verses.count
        let base = hasChorus ? "\(count - 1) V" : "\(count) V"
        return count == 1 ? base : "\(base)s"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .center) {
                Text(
                    SongUtils.songItemTitle(number: song.songNo, title: song.title)
                )
                    .font(.title3)
                    .foregroundColor(.scrim)
                    .fontWeight(.bold)
                    .lineLimit(1)

                Spacer()

                TagItem(tagText: versesText, height: height)

                if hasChorus {
                    TagItem(tagText: chorusText, height: height)
                }

                Image(systemName: song.liked ? "heart.fill" : "heart")
                    .foregroundColor(.scrim)
            }

            Text(SongUtils.refineContent(txt: verses.first ?? ""))
                .lineLimit(2)
                .foregroundColor(.scrim)
                .font(.body)
                .multilineTextAlignment(.leading)

            if isSearching {
                TagItem(tagText: "Book \(song.book)", height: height)
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(isSelected ? .primary1 : Color.clear)
        .contentShape(Rectangle())
    }
}
