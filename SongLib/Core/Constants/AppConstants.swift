//
//  AppConstants.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

struct AppConstants {
    static let appTitle = "SongLib"
    static let appCredits1 = "Siro"
    static let appCredits2 = "Titus"
    static let entitlements = "songlib_offering_1"
    static let appLink = "https://songlib.vercel.app"
}

struct PrefConstants {
    static let installDate = "installDateKey"
    static let reviewRequested = "reviewRequestedKey"
    static let lastReviewPrompt = "lastReviewPromptKey"
    static let usageTime = "usageTimeKey"
    
    static let isSelected = "dataIsSelectedKey"
    static let isLoaded = "dataIsLoadedKey"
    static let selectedBooks = "selectedBooksKey"
    static let horizontalSlides = "horizontalSlidesKey"
    static let isProUser = "isProUser"
    static let canShowPaywall = "canShowPaywall"
    static let selectAfresh = "selectAfresh"
    static let lastAppOpenTime = "lastAppOpenTime"
}

struct AppSecrets {
    static let rc_api_key: String = {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let value = dict["REVENUECAT_API_KEY"] as? String else {
            fatalError("Missing REVENUECAT_API_KEY in Secrets.plist")
        }
        return value
    }()
}
