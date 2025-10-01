//
//  Listing.swift
//  SongLib
//
//  Created by Siro Daves on 26/08/2025.
//

import Foundation

struct Listing: Identifiable, Equatable {
    let id: Int
    var parent: Int
    var title: String
    var song: Int
    var created: Date
    var modified: Date
    
    var songCount: Int = 0
    var lastUpdate: String {
        let interval = Date().timeIntervalSince(modified)

        if interval < 60 {
            return "just now"
        } else if interval < 3600 {
            return "\(Int(interval / 60)) min ago"
        } else if interval < 86400 {
            return "\(Int(interval / 3600)) hr ago"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: modified)
        }
    }
}
