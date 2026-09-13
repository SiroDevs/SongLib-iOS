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

    private var verseCount: Int {
        verses.count - (hasChorus ? 1 : 0)
    }

    private var versesLabel: String {
        verseCount == 1 ? "1 v" : "\(verseCount) vs"
    }

    private var firstLine: String {
        SongUtils.refineContent(txt: verses.first ?? "")
    }

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            RoundedRectangle(cornerRadius: 2)
                .fill(song.liked ? Color.primary1 : Color("outline").opacity(0.35))
                .frame(width: 3, height: 36)

            VStack(alignment: .leading, spacing: 3) {
                Text(SongUtils.songItemTitle(number: song.songNo, title: song.title))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.scrim)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text(firstLine)
                    .font(.footnote)
                    .foregroundColor(Color("onSurfaceVariant").opacity(0.85))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 5) {
                Image(systemName: song.liked ? "heart.fill" : "heart")
                    .font(.system(size: 13))
                    .foregroundColor(song.liked ? .primary1 : Color("onSurfaceVariant").opacity(0.35))

                HStack(spacing: 4) {
                    SongChip(label: versesLabel)
                    if hasChorus {
                        SongChip(label: "C")
                    }
                }
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(isSelected ? Color.primary1.opacity(0.12) : Color.clear)
        .contentShape(Rectangle())
    }
}

struct SongChip: View {
    let label: String

    var body: some View {
        Text(label)
            .font(.system(size: 10, weight: .medium))
            .foregroundColor(Color("onSurfaceVariant"))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color("surfaceVariant"))
            .cornerRadius(4)
    }
}

#Preview {
    SongItem(
        song: Song.sampleSongs[0],
        height: 50,
        isSelected: false,
        isSearching: false
    )
}
