//
//  DraftsViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 04/09/2026.
//

import Foundation
import SwiftUI

final class DraftsViewModel: ObservableObject {
    @Published var drafts: [Draft] = []
    @Published var uiState: UiState = .idle

    private let draftRepo: DraftRepoProtocol

    init(draftRepo: DraftRepoProtocol) {
        self.draftRepo = draftRepo
    }

    func fetchDrafts() {
        uiState = .loading("Loading drafts ...")
        drafts = draftRepo.fetchDrafts()
        uiState = .loaded
    }

    @discardableResult
    func createDraft(title: String = "Untitled draft") -> Draft? {
        let id = draftRepo.saveDraft(title: title, content: "", songNo: nil, book: nil)
        fetchDrafts()
        return drafts.first(where: { $0.id == id })
    }

    func deleteDraft(_ draft: Draft) {
        draftRepo.deleteDraft(withId: draft.id)
        fetchDrafts()
    }
}
