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
    @ObservedObject var selected: Page
    private let prefs = PrefsRepo()

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.onPrimary)
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 3)
            
            if prefs.horizontalSlides {
                Pager(page: selected, data: verses, id: \.self) {
                    VerseContent(verse: $0)
                }
            } else {
                Pager(page: selected, data: verses, id: \.self) {
                    VerseContent(verse: $0)
                }.vertical()
            }
        }
        .padding()
    }
}

struct VerseContent: View {
    let verse: String
    
    var body: some View {
        VStack {
            Spacer(minLength: 0)

            Text(verse)
                .font(.system(size: 30, weight: .medium))
                .foregroundColor(.scrim)
                .multilineTextAlignment(.center)
                .lineSpacing(8)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
    }
}

#Preview{
    PresenterView(
        song: Song.sampleSongs[3],
    )
}
