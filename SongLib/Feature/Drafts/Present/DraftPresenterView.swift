//
//  DraftPresenterView.swift
//  SongLib
//
//  Created by Siro Daves on 04/09/2026.
//

import SwiftUI
import SwiftUIPager

/// Presents a draft's verses using the same paged-slide components the
/// song presenter uses (PresenterTabs/PresenterIndicators), but driven
/// from locally-parsed draft content instead of a fetched Song.
struct DraftPresenterView: View {
    @Environment(\.presentationMode) var presentationMode
    let title: String
    let verses: [String]
    let indicators: [String]

    @StateObject private var selectedPage = Page.first()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                PresenterTabs(verses: verses, indicators: indicators, songTitle: title, selected: selectedPage)
                    .frame(maxHeight: .infinity)

                PresenterIndicators(indicators: indicators, selected: selectedPage)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .background(.surface)
            .navigationTitle(title.isEmpty ? "Draft" : title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: { Image(systemName: "chevron.backward") }
                }
            }
        }
    }
}
