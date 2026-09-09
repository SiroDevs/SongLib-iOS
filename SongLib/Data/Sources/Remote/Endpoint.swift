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
    case songsByBook(booksIds: String, page: Int = 1, limit: Int = 500)

    private static let apiVersion = "v2"

    var path: String {
        switch self {
            case .books:
                return "/api/\(Endpoint.apiVersion)/books"

            case .songs:
                return "/api/\(Endpoint.apiVersion)/songs"

            case .songsByBook(let booksIds, _, _):
                return "/api/\(Endpoint.apiVersion)/songs/books/\(booksIds)"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
            case .songsByBook(_, let page, let limit):
                return [
                    URLQueryItem(name: "page", value: "\(page)"),
                    URLQueryItem(name: "limit", value: "\(limit)")
                ]
            default:
                return nil
        }
    }

    var url: URL? {
        var components = URLComponents(string: "https://songlive.vercel.app" + path)
        components?.queryItems = queryItems
        return components?.url
    }
}
