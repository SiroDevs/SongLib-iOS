//
//  PrefsRepo.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

protocol PrefsRepoProtocol {
    var installDate: Date { get set }
    var reviewRequested: Bool { get set }
    var lastReviewPrompt: Date { get set }
    var usageTime: TimeInterval { get set }
    var isDataSelected: Bool { get set }
    var isDataLoaded: Bool { get set }
    var selectedBooks: String { get set }
    var horizontalSlides: Bool { get set }
    var selectAfresh: Bool { get set }
    var isProUser: Bool { get set }
    var lastAppOpenTime: TimeInterval { get set }
    
    func resetPrefs()
    func hasTimeExceeded(hours: Int) -> Bool
    func updateAppOpenTime()
    func getTimeSinceLastOpen() -> TimeInterval
}

class PrefsRepo: PrefsRepoProtocol {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var installDate: Date {
        get { userDefaults.object(forKey: PrefConstants.installDate) as? Date ?? Date() }
        set { userDefaults.set(newValue, forKey: PrefConstants.installDate) }
    }
    
    var reviewRequested: Bool {
        get { userDefaults.bool(forKey: PrefConstants.reviewRequested) }
        set { userDefaults.set(newValue, forKey: PrefConstants.reviewRequested) }
    }
    
    var lastReviewPrompt: Date {
        get { userDefaults.object(forKey: PrefConstants.lastReviewPrompt) as? Date ?? .distantPast }
        set { userDefaults.set(newValue, forKey: PrefConstants.lastReviewPrompt) }
    }
    
    var usageTime: TimeInterval {
        get { userDefaults.double(forKey: PrefConstants.usageTime) }
        set { userDefaults.set(newValue, forKey: PrefConstants.usageTime) }
    }
    
    var isDataSelected: Bool {
        get { userDefaults.bool(forKey: PrefConstants.isSelected) }
        set { userDefaults.set(newValue, forKey: PrefConstants.isSelected) }
    }
    
    var isDataLoaded: Bool {
        get { userDefaults.bool(forKey: PrefConstants.isLoaded) }
        set { userDefaults.set(newValue, forKey: PrefConstants.isLoaded) }
    }
    
    var selectedBooks: String {
        get { userDefaults.string(forKey: PrefConstants.selectedBooks) ?? "" }
        set { userDefaults.set(newValue, forKey: PrefConstants.selectedBooks) }
    }
    
    var horizontalSlides: Bool {
        get { userDefaults.bool(forKey: PrefConstants.horizontalSlides) }
        set { userDefaults.set(newValue, forKey: PrefConstants.horizontalSlides) }
    }
    
    var selectAfresh: Bool {
        get { userDefaults.bool(forKey: PrefConstants.selectAfresh) }
        set { userDefaults.set(newValue, forKey: PrefConstants.selectAfresh) }
    }
    
    var isProUser: Bool {
        get { userDefaults.bool(forKey: PrefConstants.isProUser) }
        set { userDefaults.set(newValue, forKey: PrefConstants.isProUser) }
    }
    
    var lastAppOpenTime: TimeInterval {
        get { userDefaults.double(forKey: PrefConstants.lastAppOpenTime) }
        set { userDefaults.set(newValue, forKey: PrefConstants.lastAppOpenTime) }
    }
    
    func hasTimeExceeded(hours: Int) -> Bool {
        let lastTime = lastAppOpenTime
        if lastTime == 0 { return false }
        
        let currentTime = Date().timeIntervalSince1970
        let timeDifference = currentTime - lastTime
        let hoursInSeconds = TimeInterval(hours * 60 * 60)
        
        return timeDifference >= hoursInSeconds
    }
    
    func updateAppOpenTime() {
        lastAppOpenTime = Date().timeIntervalSince1970
    }
    
    func getTimeSinceLastOpen() -> TimeInterval {
        let lastTime = lastAppOpenTime
        if lastTime == 0 { return 0 }
        return Date().timeIntervalSince1970 - lastTime
    }
    
    func resetPrefs() {
        selectedBooks = ""
        isDataSelected = false
        isDataLoaded = false
        selectAfresh = false
    }
    
}
