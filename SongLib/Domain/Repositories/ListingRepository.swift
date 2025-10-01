//
//  ListingRepository.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import Foundation

protocol ListingRepositoryProtocol {
    func fetchListings(for parent: Int) -> [Listing]
    func saveListing(_ parent: Int, title: String)
    func saveListItem(_ parent: Listing, song: Int)
    func updateListing(_ listing: Listing, title: String)
    func deleteListing(with id: Int)
    func deleteListings()
}

class ListingRepository: ListingRepositoryProtocol {
    private let listData: ListingDataManager
    
    init(listData: ListingDataManager) {
        self.listData = listData
    }
    
    func fetchListings(for parent: Int) -> [Listing] {
        let listings = listData.fetchListings(with: parent)
        return listings.sorted { $1.modified < $0.modified }
    }
    
    func saveListing(_ parent: Int, title: String) {
        listData.saveListing(parent, title: title, song: 0)
    }
    
    func saveListItem(_ parent: Listing, song: Int) {
        listData.saveListing(parent.id, title: "", song: song)
        listData.updateListing(parent, title: parent.title)
    }
    
    func updateListing(_ listing: Listing, title: String) {
        listData.updateListing(listing, title: title)
    }
    
    func deleteListing(with id: Int) {
        listData.deleteListing(with: id)
    }
    
    func deleteListings(with id: Int) {
        listData.deleteListing(with: id)
    }
    
    func deleteListings() {
        listData.deleteAllListings()
    }
}
