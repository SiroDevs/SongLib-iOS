//
//  PagedResponse.swift
//  SongLib
//
//  Created by Siro Daves on 04/09/2026.
//

import Foundation

struct PaginationMeta: Codable {
    let page: Int
    let limit: Int
    let total: Int
    let totalPages: Int
    let hasMore: Bool
}

struct PagedSongsResponse: Codable {
    let data: [Song]
    let pagination: PaginationMeta
}
