//
//  SampleListings.swift
//  SongLib
//
//  Created by Siro Daves on 28/08/2025.
//

import Foundation

extension Listing {
    static let sampleListings: [Listing] = [
        Listing(
            id: 1,
            parent: 0,
            title: "Sunday Service",
            song: 0,
            created: Date().addingTimeInterval(-3600),
            modified: Date().addingTimeInterval(-600),
            songCount: 12
        ),
        Listing(
            id: 2,
            parent: 0,
            title: "Wedding Playlist",
            song: 0,
            created: Date().addingTimeInterval(-86400),
            modified: Date().addingTimeInterval(-7200),
            songCount: 8
        )
    ]
}
