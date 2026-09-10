//
//  SearchBookItem.swift
//  SongLib
//
//  Created by Siro Daves on 04/05/2025.
//

import SwiftUI

struct BookItem: View {
    let text: String
    let isSelected: Bool
    let onPressed: (() -> Void)?

    var body: some View {
        let bgColor = isSelected ? .primary1 : Color("onPrimary")
        let txtColor = isSelected ? Color("onPrimary") : .scrim

        Button(action: {
            onPressed?()
        }) {
            Text(text)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(txtColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(bgColor)
                .cornerRadius(14)
        }
        .buttonStyle(PlainButtonStyle())
        .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 1)
    }
}

#Preview{
    BookItem(
        text: "Songs of Worship",
        isSelected: true,
        onPressed: { }
    )
}
