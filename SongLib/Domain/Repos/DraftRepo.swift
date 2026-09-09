//
//  DraftRepo.swift
//  SongLib
//
//  Created by Siro Daves on 04/09/2026.
//

import Foundation

/// Local-only draft storage. Android syncs drafts to the server once a
/// user is logged in (`syncDraftsToRemote(userId:)`); iOS has no account
/// system, so drafts simply stay on-device — same shape Android drafts
/// have before login.
protocol DraftRepoProtocol {
    func fetchDrafts() -> [Draft]
    func fetchDraft(withId id: Int) -> Draft?
    @discardableResult
    func saveDraft(title: String, content: String, songNo: Int?, book: Int?) -> Int
    func updateDraft(_ draft: Draft)
    func deleteDraft(withId id: Int)
    func deleteAllDrafts()
}

class DraftRepo: DraftRepoProtocol {
    private let draftData: DraftDataManager

    init(draftData: DraftDataManager) {
        self.draftData = draftData
    }

    func fetchDrafts() -> [Draft] {
        draftData.fetchDrafts()
    }

    func fetchDraft(withId id: Int) -> Draft? {
        draftData.fetchDraft(withId: id)
    }

    @discardableResult
    func saveDraft(title: String, content: String, songNo: Int? = nil, book: Int? = nil) -> Int {
        draftData.saveDraft(title: title, content: content, songNo: songNo, book: book)
    }

    func updateDraft(_ draft: Draft) {
        draftData.updateDraft(draft)
    }

    func deleteDraft(withId id: Int) {
        draftData.deleteDraft(withId: id)
    }

    func deleteAllDrafts() {
        draftData.deleteAllDrafts()
    }
}
