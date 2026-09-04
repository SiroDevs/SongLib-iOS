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
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(txtColor)
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .background(bgColor)
                .cornerRadius(20)
        }
        .padding(.bottom, 5)
        .buttonStyle(PlainButtonStyle())
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}

#Preview{
    BookItem(
        text: "Songs of Worship",
        isSelected: true,
        onPressed: { }
    )
}
