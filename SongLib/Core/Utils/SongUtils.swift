//
//  SongUtils.swift
//  SongLib
//
//  Created by Siro Daves on 02/05/2025.
//

import Foundation

class SongUtils {
    
    static func refineTitle(txt: String) -> String {
        return txt.replacingOccurrences(of: "''", with: "'")
    }
    
    static func refineContent(txt: String) -> String {
        return txt.replacingOccurrences(of: "''", with: "'").replacingOccurrences(of: "#", with: " ")
    }
    
    static func refineShareContent(txt: String) -> String {
        return txt.replacingOccurrences(of: "''", with: "'").replacingOccurrences(of: "#", with: "\n")
    }
    
    static func songItemTitle(number: Int, title: String) -> String {
        return number != 0 ? "\(number). \(refineTitle(txt: title))" : refineTitle(txt: title)
    }
    
    static func getSongVerses(songContent: String) -> [String] {
        return songContent.split(separator: "##").map { $0.replacingOccurrences(of: "#", with: "\n") }
    }
    
    static func songViewerTitle(number: Int, title: String, alias: String) -> String {
        var songTitle = "\(number). \(refineTitle(txt: title))"
        if alias.count > 2 && title != alias {
            songTitle = "\(songTitle) (\(refineTitle(txt: alias)))"
        }
        return songTitle
    }
    
    static func searchSongs(
        songs: [Song],
        qry: String,
        byNo: Bool = false
    ) -> [Song] {
        
        let search = qry.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !search.isEmpty else { return songs }
        
        if byNo {
            if let number = Int(search) {
                return songs.filter { $0.songNo == number }
            } else {
                return []
            }
        }
        
        if search.count <= 3, let number = Int(search) {
            return songs.filter { $0.songNo == number }
        }
        
        let charsPattern = try! NSRegularExpression(pattern: "[!,]", options: [])
        
        let words: [String]
        if search.contains(",") {
            words = search
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces).lowercased() }
        } else {
            words = [search.lowercased()]
        }
        
        let escapedWords = words.map { NSRegularExpression.escapedPattern(for: $0) }
        let pattern = escapedWords.joined(separator: ".*")
        let regex = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        
        return songs.filter { song in
            let title = charsPattern.stringByReplacingMatches(
                in: song.title,
                range: NSRange(song.title.startIndex..., in: song.title),
                withTemplate: ""
            ).lowercased()
            
            let alias = charsPattern.stringByReplacingMatches(
                in: song.alias,
                range: NSRange(song.alias.startIndex..., in: song.alias),
                withTemplate: ""
            ).lowercased()
            
            let content = charsPattern.stringByReplacingMatches(
                in: song.content,
                range: NSRange(song.content.startIndex..., in: song.content),
                withTemplate: ""
            ).lowercased()
            
            let fields = [title, alias, content]
            return fields.contains { field in
                regex.firstMatch(in: field, range: NSRange(field.startIndex..., in: field)) != nil
            }
        }
    }
    
    static func shareText(song: Song) -> String {
        var text = "\(SongUtils.songItemTitle(number: song.songNo, title: song.title))\n\n"
        text += SongUtils.refineContent(txt: song.content)
        text += "\n\n\(AppConstants.appTitle)\n\(AppConstants.appLink)\n"
        
        return text
    }

}
