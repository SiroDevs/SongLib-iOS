//
//  Draft.swift
//  SongLib
//
//  Created by Siro Daves on 04/09/2026.
//

import Foundation

struct Draft: Identifiable, Equatable {
    let id: Int
    var title: String
    var content: String
    var songNo: Int? = nil
    var book: Int? = nil
    var created: String
    var modified: String? = nil

    private static let isoFormatter = ISO8601DateFormatter()

    var updatedAgo: String {
        let reference = Draft.isoFormatter.date(from: modified ?? "")
            ?? Draft.isoFormatter.date(from: created)
            ?? Date()

        let interval = Date().timeIntervalSince(reference)

        if interval < 60 {
            return "just now"
        } else if interval < 3600 {
            return "\(Int(interval / 60)) min ago"
        } else if interval < 86400 {
            return "\(Int(interval / 3600)) hr ago"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: reference)
        }
    }
}
