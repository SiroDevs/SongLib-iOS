//
//  ShareCards.swift
//  SongLib
//
//  Created by Siro Daves on 11/09/2026.
//

import SwiftUI

/// Formatted card rendered only to be captured into an image for sharing -
/// it's never shown directly in the UI, just drawn off-screen (see
/// `VerseShareButtons`) and turned into a snapshot. Mirrors Android's
/// `ShareCardTemplate`.
struct ShareCardTemplate: View {
    let label: String
    let content: String
    let contentFont: Font
    let songTitle: String
    let bookName: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(label.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .tracking(2)
                .foregroundColor(.primary1)

            Text(content.trimmingCharacters(in: .whitespacesAndNewlines))
                .font(contentFont)
                .foregroundColor(.onPrimaryContainer)
                .multilineTextAlignment(.leading)

            Rectangle()
                .fill(Color.primary1.opacity(0.3))
                .frame(height: 1)

            VStack(alignment: .leading, spacing: 2) {
                Text(songTitle)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.onPrimaryContainer)

                if let bookName, !bookName.isEmpty {
                    Text(bookName)
                        .font(.subheadline)
                        .foregroundColor(.onPrimaryContainer.opacity(0.75))
                }
            }

            Text("SongLib")
                .font(.caption)
                .foregroundColor(.primary1.opacity(0.6))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(28)
        .frame(width: 320, alignment: .leading)
        .background(Color.primaryContainer)
        .cornerRadius(16)
    }
}

/// Single-verse share card: verse text plus song title/book footer.
struct VerseShareCard: View {
    let verseLabel: String
    let verseText: String
    let songTitle: String
    let bookName: String?

    var body: some View {
        ShareCardTemplate(
            label: verseLabel,
            content: verseText,
            contentFont: .system(size: 20, weight: .medium),
            songTitle: songTitle,
            bookName: bookName
        )
    }
}
