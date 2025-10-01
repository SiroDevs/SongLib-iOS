//
//  HistoryDataManager.swift
//  SongLib
//
//  Created by Siro Daves on 26/08/2025.
//

import CoreData

class HistoryDataManager {
    private let cdManager: CoreDataManager
        
    init(cdManager: CoreDataManager = CoreDataManager.shared) {
        self.cdManager = cdManager
    }
    
    private var context: NSManagedObjectContext {
        return cdManager.viewContext
    }
    
    func saveHistory(_ songId: Int) {
        context.perform {
            do {
                let cdHistory = CDHistory(context: self.context)
                cdHistory.id = self.cdManager.nextId(context: self.context, entity: "CDHistory")
                cdHistory.song = Int32(songId)
                cdHistory.created = Date()
                
                try self.context.save()
            } catch {
                print("❌ Failed to save history: \(error)")
            }
        }
    }
    
    func fetchHistories() -> [History] {
        let fetchRequest: NSFetchRequest<CDHistory> = CDHistory.fetchRequest()
        do {
            let cdHistoryes = try context.fetch(fetchRequest)
            return cdHistoryes.compactMap { cdHistory in
                return History(
                    id: Int(cdHistory.id),
                    song: Int(cdHistory.song),
                    created: cdHistory.created!
                )
            }
        } catch {
            print("❌ Failed to fetch histories: \(error)")
            return []
        }
    }
    
    func fetchHistory(withId id: Int) -> History? {
        let fetchRequest: NSFetchRequest<CDHistory> = CDHistory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let cdHistory = results.first else { return nil }
            
            return History(
                id: Int(cdHistory.id),
                song: Int(cdHistory.song),
                created: cdHistory.created!
            )
        } catch {
            print("❌ Failed to fetch history: \(error)")
            return nil
        }
    }
    
    func deleteView(withId id: Int) {
        let fetchRequest: NSFetchRequest<CDHistory> = CDHistory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let viewToDelete = results.first {
                context.delete(viewToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete history: \(error)")
        }
    }
    
    func deleteAllHistories() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDHistory.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All histories deleted successfully")
        } catch {
            print("❌ Failed to delete histories: \(error)")
        }
    }
}
