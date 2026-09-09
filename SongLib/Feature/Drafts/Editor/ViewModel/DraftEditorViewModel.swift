//
//  DraftEditorViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 04/09/2026.
//

import Foundation
import SwiftUI

final class DraftEditorViewModel: ObservableObject {
    @Published var title: String
    @Published var content: String

    @Published var indicators: [String] = []
    @Published var verses: [String] = []

    private let draftRepo: DraftRepoProtocol
    private let draft: Draft

    init(draftRepo: DraftRepoProtocol, draft: Draft?) {
        self.draftRepo = draftRepo
        self.draft = draft ?? Draft(
            id: 0, title: "", content: "",
            created: ISO8601DateFormatter().string(from: Date())
        )
        self.title = self.draft.title
        self.content = self.draft.content
    }

    func save() {
        guard draft.id != 0 else { return }
        var updated = draft
        updated.title = title
        updated.content = content
        draftRepo.updateDraft(updated)
    }

    /// Parses the draft content into presenter verses, reusing the same
    /// verse-splitting logic songs use so drafts present identically.
    func preparePresentation() {
        indicators = []
        verses = []

        let hasChorus = content.contains("CHORUS")
        let draftVerses = SongUtils.getSongVerses(songContent: content)
        let verseCount = draftVerses.count

        guard verseCount > 0 else { return }

        if hasChorus, verseCount > 1 {
            let chorus = draftVerses[1].replacingOccurrences(of: "CHORUS#", with: "")

            indicators.append("1")
            indicators.append("C")
            verses.append(draftVerses[0])
            verses.append(chorus)

            for i in 2..<verseCount {
                indicators.append("\(i)")
                indicators.append("C")
                verses.append(draftVerses[i])
                verses.append(chorus)
            }
        } else {
            for i in 0..<verseCount {
                indicators.append("\(i + 1)")
                verses.append(draftVerses[i])
            }
        }
    }
}
