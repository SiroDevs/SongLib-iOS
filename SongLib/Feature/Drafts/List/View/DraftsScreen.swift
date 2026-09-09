//
//  DraftsScreen.swift
//  SongLib
//
//  Created by Siro Daves on 04/09/2026.
//

import SwiftUI

struct DraftsScreen: View {
    @StateObject private var viewModel: DraftsViewModel = {
        DiContainer.shared.resolve(DraftsViewModel.self)
    }()

    @State private var editingDraft: Draft?
    @State private var showEditor = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.drafts.isEmpty {
                    EmptyState(
                        title: "No drafts yet",
                        message: "Drafts are saved on this device only."
                    )
                } else {
                    List {
                        ForEach(viewModel.drafts) { draft in
                            Button {
                                editingDraft = draft
                                showEditor = true
                            } label: {
                                DraftRow(draft: draft)
                            }
                            .foregroundColor(.primary)
                        }
                        .onDelete(perform: deleteDrafts)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Drafts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        editingDraft = viewModel.createDraft()
                        showEditor = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .task { viewModel.fetchDrafts() }
            .sheet(isPresented: $showEditor, onDismiss: { viewModel.fetchDrafts() }) {
                if let draft = editingDraft {
                    NavigationStack {
                        DraftEditorView(draft: draft)
                    }
                }
            }
        }
    }

    private func deleteDrafts(at offsets: IndexSet) {
        for index in offsets {
            viewModel.deleteDraft(viewModel.drafts[index])
        }
    }
}

private struct DraftRow: View {
    let draft: Draft

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(draft.title.isEmpty ? "Untitled draft" : draft.title)
                .font(.headline)
            Text(draft.updatedAgo)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
