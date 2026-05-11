//
//  PresenterContent.swift
//  SongLib
//
//  Created by Siro Daves on 26/08/2025.
//

import SwiftUI
import SwiftUIPager

struct PresenterContent: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ListingViewModel
    @ObservedObject var selected: Page
    let song: Song
    
    var body: some View {
        VStack(spacing: 20) {
            PresenterTabs(
                verses: viewModel.verses,
                selected: selected
            )
            .frame(maxHeight: .infinity)
            
            PresenterIndicators(
                indicators: viewModel.indicators,
                selected: selected
            )
            .fixedSize(horizontal: false, vertical: true)
        }
        .background(.surface)
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: { Image(systemName: "chevron.backward") }
            }

            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    viewModel.likeSong(song: song)
                } label: {
                    Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                        .foregroundColor(.primary1)
                }

                ShareLink(
                    item: SongUtils.shareText(song: song),
                ) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.primary1)
                }
            }
        }
    }
}
