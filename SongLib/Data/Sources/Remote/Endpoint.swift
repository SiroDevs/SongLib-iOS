//
//  Endpoint.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

enum Endpoint {
    case books
    case songs
    case songsByBook(String)
    
    var path: String {
        switch self {
        case .books:
            return "/books"
        case .songs:
            return "/songs"
        case .songsByBook(let booksIds):
            return "/songs/books/\(booksIds)"
        }
    }
    
    var url: URL? {
        return URL(string: "https://songlive.vercel.app/api" + path)
    }
}
