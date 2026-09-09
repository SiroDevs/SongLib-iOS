//
//  DraftDataManager.swift
//  SongLib
//
//  Created by Siro Daves on 04/09/2026.
//

import CoreData

class DraftDataManager {
    private let cdManager: CoreDataManager
    private let isoFormatter = ISO8601DateFormatter()

    init(cdManager: CoreDataManager = .shared) {
        self.cdManager = cdManager
    }

    private var context: NSManagedObjectContext {
        cdManager.viewContext
    }

    @discardableResult
    func saveDraft(title: String, content: String, songNo: Int? = nil, book: Int? = nil) -> Int {
        var newId = 0
        context.performAndWait {
            do {
                let cdDraft = CDDraft(context: self.context)
                newId = Int(self.cdManager.nextId(context: self.context, entity: "CDDraft"))
                let now = self.isoFormatter.string(from: Date())
                cdDraft.id = Int32(newId)
                cdDraft.title = title
                cdDraft.content = content
                if let songNo = songNo { cdDraft.songNo = Int32(songNo) }
                if let book = book { cdDraft.book = Int32(book) }
                cdDraft.created = now
                cdDraft.modified = now
                try self.context.save()
            } catch {
                print("❌ Failed to save draft: \(error)")
            }
        }
        return newId
    }

    func fetchDrafts() -> [Draft] {
        let request: NSFetchRequest<CDDraft> = CDDraft.fetchRequest()
        // String-typed dates are ISO8601, which sort correctly as strings.
        request.sortDescriptors = [NSSortDescriptor(key: "modified", ascending: false)]
        do {
            let cdDrafts = try context.fetch(request)
            return cdDrafts.map(mapCDDraft)
        } catch {
            print("❌ Failed to fetch drafts: \(error)")
            return []
        }
    }

    func fetchDraft(withId id: Int) -> Draft? {
        do {
            guard let cdDraft = try fetchCDDraft(with: id) else { return nil }
            return mapCDDraft(cdDraft)
        } catch {
            print("❌ Failed to fetch draft with ID \(id): \(error)")
            return nil
        }
    }

    func updateDraft(_ draft: Draft) {
        context.perform {
            do {
                guard let cdDraft = try self.fetchCDDraft(with: draft.id) else {
                    print("⚠️ Draft with ID \(draft.id) not found.")
                    return
                }
                cdDraft.title = draft.title
                cdDraft.content = draft.content
                if let songNo = draft.songNo { cdDraft.songNo = Int32(songNo) }
                if let book = draft.book { cdDraft.book = Int32(book) }
                cdDraft.modified = self.isoFormatter.string(from: Date())
                try self.context.save()
            } catch {
                print("❌ Failed to update draft \(draft.id): \(error)")
            }
        }
    }

    func deleteDraft(withId id: Int) {
        context.perform {
            do {
                guard let cdDraft = try self.fetchCDDraft(with: id) else { return }
                self.context.delete(cdDraft)
                try self.context.save()
            } catch {
                print("❌ Failed to delete draft with ID \(id): \(error)")
            }
        }
    }

    func deleteAllDrafts() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDDraft.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All drafts deleted successfully")
        } catch {
            print("❌ Failed to delete drafts: \(error)")
        }
    }

    private func mapCDDraft(_ cdDraft: CDDraft) -> Draft {
        Draft(
            id: Int(cdDraft.id),
            title: cdDraft.title ?? "Untitled draft",
            content: cdDraft.content ?? "",
            songNo: cdDraft.songNo == 0 ? nil : Int(cdDraft.songNo),
            book: cdDraft.book == 0 ? nil : Int(cdDraft.book),
            created: cdDraft.created ?? isoFormatter.string(from: Date()),
            modified: cdDraft.modified
        )
    }

    private func fetchCDDraft(with id: Int) throws -> CDDraft? {
        let request: NSFetchRequest<CDDraft> = CDDraft.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
}
