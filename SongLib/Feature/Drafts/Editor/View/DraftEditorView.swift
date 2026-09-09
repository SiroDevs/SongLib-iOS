//
//  DraftEditorView.swift
//  SongLib
//
//  Created by Siro Daves on 04/09/2026.
//

import SwiftUI

struct DraftEditorView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: DraftEditorViewModel
    @State private var showPresenter = false

    init(draft: Draft) {
        _viewModel = StateObject(wrappedValue: DiContainer.shared.resolve(
            DraftEditorViewModel.self,
            argument: Optional(draft)
        ))
    }

    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Draft title", text: $viewModel.title)
            }

            Section(header: Text("Content")) {
                TextEditor(text: $viewModel.content)
                    .frame(minHeight: 220)
            }
        }
        .navigationTitle("Edit Draft")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Done") {
                    viewModel.save()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.save()
                    viewModel.preparePresentation()
                    showPresenter = true
                } label: {
                    Image(systemName: "play.fill")
                }
                .disabled(viewModel.content.isEmpty)
            }
        }
        .fullScreenCover(isPresented: $showPresenter) {
            DraftPresenterView(title: viewModel.title, verses: viewModel.verses, indicators: viewModel.indicators)
        }
    }
}
