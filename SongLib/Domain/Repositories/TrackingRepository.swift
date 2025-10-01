//
//  TrackingRepository.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import Foundation

protocol TrackingRepositoryProtocol {
    func fetchHistories() -> [History]
    func fetchSearches() -> [Search]
    func saveHistory(_ songId: Int)
    func saveSearch(_ title: String)
    func deleteHistory()
    func deleteSearch()
}

class TrackingRepository: TrackingRepositoryProtocol {
    private let historyData: HistoryDataManager
    private let searchData: SearchDataManager
    
    init(historyData: HistoryDataManager, searchData: SearchDataManager) {
        self.historyData = historyData
        self.searchData = searchData
    }
    
    func fetchHistories() -> [History] {
        let historys = historyData.fetchHistories()
        return historys.sorted { $0.created < $1.created }
    }
    
    func fetchSearches() -> [Search] {
        let searches = searchData.fetchSearches()
        return searches.sorted { $0.created < $1.created }
    }
    
    func saveHistory(_ songId: Int) {
        historyData.saveHistory(songId)
    }
    
    func saveSearch(_ title: String) {
        searchData.saveSearch(title)
    }
    
    func deleteHistory() {
        historyData.deleteAllHistories()
    }
    
    func deleteSearch() {
        searchData.deleteAllSearches()
    }
    
}
