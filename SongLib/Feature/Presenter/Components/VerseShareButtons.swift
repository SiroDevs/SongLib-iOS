//
//  VerseShareButtons.swift
//  SongLib
//
//  Created by Siro Daves on 11/09/2026.
//

import SwiftUI
import UIKit

/// "Copy" and "Share" actions for a single verse, shown at the bottom of
/// its slide. Copy puts plain text on the clipboard; Share renders
/// `VerseShareCard` to an image and hands it to the system share sheet -
/// same two actions Android offers per verse.
struct VerseShareButtons: View {
    let songTitle: String
    let bookName: String?
    let verseLabel: String
    let verseText: String

    @State private var copied = false
    @State private var isRendering = false
    @State private var shareImage: UIImage?
    @State private var showShareSheet = false

    private var shareText: String {
        var text = verseText.trimmingCharacters(in: .whitespacesAndNewlines)
        text += "\n\n\(songTitle)"
        if let bookName, !bookName.isEmpty {
            text += " · \(bookName)"
        }
        text += "\n\nvia SongLib \(AppConstants.appLink)"
        return text
    }

    var body: some View {
        HStack(spacing: 12) {
            Button(action: copyVerse) {
                Label(copied ? "Copied" : "Copy", systemImage: copied ? "checkmark" : "doc.on.doc")
            }
            .buttonStyle(.bordered)

            Button(action: shareVerse) {
                Label(isRendering ? "…" : "Share", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(.bordered)
            .disabled(isRendering)
        }
        .font(.footnote.weight(.medium))
        .tint(.primary1)
        .sheet(isPresented: $showShareSheet) {
            if let shareImage {
                ShareSheet(items: [shareImage])
            }
        }
    }

    private func copyVerse() {
        UIPasteboard.general.string = shareText
        withAnimation { copied = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { copied = false }
        }
    }

    @MainActor
    private func shareVerse() {
        guard !isRendering else { return }
        isRendering = true

        let card = VerseShareCard(
            verseLabel: verseLabel,
            verseText: verseText,
            songTitle: songTitle,
            bookName: bookName
        )
        let renderer = ImageRenderer(content: card)
        renderer.scale = UIScreen.main.scale

        shareImage = renderer.uiImage
        isRendering = false
        showShareSheet = shareImage != nil
    }
}
