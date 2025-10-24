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
            RoundedRectangle(cornerRadius: 15)
                .fill(.onPrimary)
                .shadow(radius: 5)
            
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
        VStack(alignment: .leading, spacing: 15) {
            Text(verse)
                .font(.largeTitle)
                .foregroundColor(.scrim)
                .multilineTextAlignment(.leading)
        }
        .padding(15)
    }
}

#Preview{
    PresenterView(
        song: Song.sampleSongs[3],
    )
}
