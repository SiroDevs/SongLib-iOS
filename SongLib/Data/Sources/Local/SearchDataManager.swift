//
//  SearchDataManager.swift
//  SongLib
//
//  Created by Siro Daves on 26/08/2025.
//

import CoreData

class SearchDataManager {
    private let cdManager: CoreDataManager
        
    init(cdManager: CoreDataManager = CoreDataManager.shared) {
        self.cdManager = cdManager
    }
    
    private var context: NSManagedObjectContext {
        return cdManager.viewContext
    }
    
    func saveSearch(_ title: String) {
        context.perform {
            do {
                let cdSearch = CDSearch(context: self.context)
                cdSearch.id = self.cdManager.nextId(context: self.context, entity: "CDSearch")
                cdSearch.title = title
                cdSearch.created = Date()
                
                try self.context.save()
            } catch {
                print("❌ Failed to save searches: \(error)")
            }
        }
    }
    
    func fetchSearches() -> [Search] {
        let fetchRequest: NSFetchRequest<CDSearch> = CDSearch.fetchRequest()
        do {
            let cdSearches = try context.fetch(fetchRequest)
            return cdSearches.compactMap { cdSearch in
                return Search(
                    id: Int(cdSearch.id),
                    title: cdSearch.title ?? "",
                    created: cdSearch.created!
                )
            }
        } catch {
            print("❌ Failed to fetch searches: \(error)")
            return []
        }
    }
    
    func fetchSearch(withId id: Int) -> Search? {
        let fetchRequest: NSFetchRequest<CDSearch> = CDSearch.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let cdSearch = results.first else { return nil }
            
            return Search(
                id: Int(cdSearch.id),
                title: cdSearch.title ?? "",
                created: cdSearch.created!
            )
        } catch {
            print("❌ Failed to fetch search: \(error)")
            return nil
        }
    }
    
    func deleteSearch(withId id: Int) {
        let fetchRequest: NSFetchRequest<CDSearch> = CDSearch.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let searchToDelete = results.first {
                context.delete(searchToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete search: \(error)")
        }
    }
    
    func deleteAllSearches() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDSearch.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All searches deleted successfully")
        } catch {
            print("❌ Failed to delete searches: \(error)")
        }
    }
}
