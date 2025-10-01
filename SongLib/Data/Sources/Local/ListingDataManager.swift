//
//  ListingDataManager.swift
//  ListingLib
//
//  Created by Siro Daves on 26/08/2025.
//

import CoreData

class ListingDataManager {
    private let cdManager: CoreDataManager
    
    init(cdManager: CoreDataManager = .shared) {
        self.cdManager = cdManager
    }
    
    private var context: NSManagedObjectContext {
        cdManager.viewContext
    }
    
    func saveListing(_ parent: Int, title: String, song: Int) {
        context.perform {
            do {
                let cdListing = CDListing(context: self.context)
                cdListing.id = self.cdManager.nextId(context: self.context, entity: "CDListing")
                cdListing.parent = Int32(parent)
                cdListing.title = title
                cdListing.song = Int32(song)
                cdListing.created = Date()
                cdListing.modified = Date()
                try self.context.save()
            } catch {
                print("❌ Failed to save listing: \(error)")
            }
        }
    }
    
    func fetchListings(with parent: Int = 0) -> [Listing] {
        let request: NSFetchRequest<CDListing> = CDListing.fetchRequest()
        request.predicate = NSPredicate(format: "parent == %d", parent)
        do {
            let cdListings = try context.fetch(request)
            return cdListings.compactMap(mapCDListing)
        } catch {
            print("❌ Failed to fetch listings: \(error)")
            return []
        }
    }
    
    func updateListing(_ listing: Listing, title: String) {
        context.perform {
            do {
                guard let cdListing = try self.fetchCDListing(with: listing.id) else {
                    print("⚠️ Listing with ID \(listing.id) not found.")
                    return
                }
                cdListing.title = title
                cdListing.modified = Date()
                try self.context.save()
            } catch {
                print("❌ Failed to update listing \(listing.id): \(error)")
            }
        }
    }
    
    func deleteListing(with id: Int) {
        context.perform {
            do {
                guard let cdListing = try self.fetchCDListing(with: id) else { return }
                self.context.delete(cdListing)
                try self.context.save()
            } catch {
                print("❌ Failed to delete listing with ID \(id): \(error)")
            }
        }
    }
    
    private func mapCDListing(_ cdListing: CDListing) -> Listing? {
        let songCount = fetchChildCount(for: Int(cdListing.id))
        return Listing(
            id: Int(cdListing.id),
            parent: Int(cdListing.parent),
            title: cdListing.title ?? "Untitled listing",
            song: Int(cdListing.song),
            created: cdListing.created!,
            modified: cdListing.modified!,
            songCount: songCount
        )
    }
    
    private func fetchChildCount(for parent: Int) -> Int {
        let request: NSFetchRequest<CDListing> = CDListing.fetchRequest()
        request.predicate = NSPredicate(format: "parent == %d", parent)
        return (try? context.count(for: request)) ?? 0
    }
    
    private func fetchCDListing(with id: Int) throws -> CDListing? {
        let request: NSFetchRequest<CDListing> = CDListing.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id )
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    func deleteListing(id: Int) throws {
        try context.performAndWait {
            guard let cdListing = try fetchCDListing(with: id) else { return }
            context.delete(cdListing)
            try context.save()
        }
    }
    
    func deleteAllListings() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDListing.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("🗑️ All listings deleted successfully")
        } catch {
            print("❌ Failed to delete listings: \(error)")
        }
    }
}
