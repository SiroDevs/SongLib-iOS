//
//  PrefsRepo.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

/// Features that free (non-Pro) users get a limited number of uses of
/// before being asked to upgrade. Each case tracks its own use count
/// independently, via `PrefsRepo`. See `ProFeatureGateModel`.
enum ProFeature {
    case searchByNumber
    case songSharing
    case verseSharing

    fileprivate var prefsKey: String {
        switch self {
        case .searchByNumber: return PrefConstants.searchByNoUses
        case .songSharing: return PrefConstants.songShareUses
        case .verseSharing: return PrefConstants.verseShareUses
        }
    }
}

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
    var lastAppOpenTime: TimeInterval { get set }

    /// Cached locally so screens that don't own a subscription-checking
    /// view model (e.g. `VerseShareButtons`) can still read it
    /// synchronously, mirroring how `horizontalSlides` is read directly
    /// in `PresenterTabs`. Kept in sync by whichever view model last
    /// validated the subscription with `SubsRepo`.
    var isProUser: Bool { get set }

    func resetPrefs()
    func hasTimeExceeded(hours: Int) -> Bool
    func updateAppOpenTime()
    func getTimeSinceLastOpen() -> TimeInterval

    func proFeatureUseCount(_ feature: ProFeature) -> Int
    func recordProFeatureUse(_ feature: ProFeature)
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
    
    var lastAppOpenTime: TimeInterval {
        get { userDefaults.double(forKey: PrefConstants.lastAppOpenTime) }
        set { userDefaults.set(newValue, forKey: PrefConstants.lastAppOpenTime) }
    }

    var isProUser: Bool {
        get { userDefaults.bool(forKey: PrefConstants.isProUser) }
        set { userDefaults.set(newValue, forKey: PrefConstants.isProUser) }
    }

    func proFeatureUseCount(_ feature: ProFeature) -> Int {
        userDefaults.integer(forKey: feature.prefsKey)
    }

    func recordProFeatureUse(_ feature: ProFeature) {
        userDefaults.set(proFeatureUseCount(feature) + 1, forKey: feature.prefsKey)
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
