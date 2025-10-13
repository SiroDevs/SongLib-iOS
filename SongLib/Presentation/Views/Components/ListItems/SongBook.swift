//
//  SongBook.swift
//  SongLib
//
//  Created by Siro Daves on 02/05/2025.
//

import SwiftUI

struct SongBook: View {
    let book: Book
    let isSelected: Bool
    let onTap: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let bgColor = isSelected ? .primary1 : Color("inversePrimary")
        let txtColor = isSelected ? Color("onPrimary") : .scrim

        return ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(bgColor)
                .shadow(radius: 5)
            (
                Text(SongUtils.refineTitle(txt: book.title))
                    .font(.system(size: 20, weight: .bold))
                +
                Text(" (\(book.songs))")
                    .font(.system(size: 14))
                    .foregroundColor(txtColor.opacity(0.7))
            )
            .foregroundColor(txtColor)
            .lineLimit(3)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
        }
        .frame(maxWidth: .infinity)
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    SongBook(
        book: Book.sampleBooks[0],
        isSelected: true,
        onTap: { print("Amen") }
    )
    .padding()
}

