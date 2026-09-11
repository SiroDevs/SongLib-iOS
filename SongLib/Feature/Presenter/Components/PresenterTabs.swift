//
//  PresenterTabs.swift
//  SongLib
//
//  Created by Siro Daves on 07/05/2025.
//

import SwiftUI
import SwiftUIPager

struct PresenterTabs: View {
    let verses: [String]
    let indicators: [String]
    var songTitle: String = ""
    var bookName: String? = nil
    @ObservedObject var selected: Page

    /// Previous/next SONG (not verse) navigation, shown as tappable
    /// corners on the card - both default to "off" so `DraftPresenterView`
    /// (which has no surrounding song list) doesn't need to opt in.
    var hasPreviousSong: Bool = false
    var hasNextSong: Bool = false
    var onPreviousSong: () -> Void = {}
    var onNextSong: () -> Void = {}

    private let prefs = PrefsRepo()

    @State private var fontSize: CGFloat = AppFonts.defaultSize
    @State private var fontSizeAtGestureStart: CGFloat = AppFonts.defaultSize

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.onPrimary)
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 3)

            Group {
                if prefs.horizontalSlides {
                    Pager(page: selected, data: Array(verses.indices), id: \.self) { index in
                        verseContent(at: index)
                    }
                } else {
                    Pager(page: selected, data: Array(verses.indices), id: \.self) { index in
                        verseContent(at: index)
                    }.vertical()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))

            // Previous/next song corners - see SongNavZone.swift for what
            // image assets these expect and where to drop them.
            VStack {
                Spacer()
                HStack {
                    if hasPreviousSong {
                        SongNavZone(corner: .leading, action: onPreviousSong)
                    }
                    Spacer()
                    if hasNextSong {
                        SongNavZone(corner: .trailing, action: onNextSong)
                    }
                }
            }
            .allowsHitTesting(true)
        }
        .padding()
        // Pinch to resize verse text, clamped to AppFonts' bounds - same
        // gesture and range as the Android app's presenter.
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    let newSize = fontSizeAtGestureStart * value
                    fontSize = min(max(newSize, AppFonts.minSize), AppFonts.maxSize)
                }
                .onEnded { _ in
                    fontSizeAtGestureStart = fontSize
                }
        )
    }

    @ViewBuilder
    private func verseContent(at index: Int) -> some View {
        let verse = verses.indices.contains(index) ? verses[index] : ""
        let rawLabel = indicators.indices.contains(index) ? indicators[index] : "\(index + 1)"

        VerseContent(
            verse: verse,
            verseLabel: rawLabel == "C" ? "Chorus" : "Verse \(rawLabel)",
            songTitle: songTitle,
            bookName: bookName,
            fontSize: $fontSize
        )
    }
}

struct VerseContent: View {
    let verse: String
    let verseLabel: String
    let songTitle: String
    let bookName: String?
    @Binding var fontSize: CGFloat

    var body: some View {
        VStack(spacing: 12) {
            Spacer(minLength: 0)

            // `minimumScaleFactor` lets the verse shrink itself down to
            // fit rather than clipping when it's too long for the card at
            // the current (possibly pinch-zoomed) font size - the "auto
            // sizing" behaviour, on top of the manual pinch control.
            Text(verse)
                .font(.system(size: fontSize, weight: .medium))
                .foregroundColor(.scrim)
                .multilineTextAlignment(.center)
                .lineSpacing(fontSize * 0.25)
                .lineLimit(nil)
                .minimumScaleFactor(0.4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            Spacer(minLength: 0)

            if !songTitle.isEmpty {
                VerseShareButtons(
                    songTitle: songTitle,
                    bookName: bookName,
                    verseLabel: verseLabel,
                    verseText: verse
                )
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview{
    PresenterView(
        song: Song.sampleSongs[3],
    )
}
