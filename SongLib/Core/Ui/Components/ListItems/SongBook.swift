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

    var body: some View {
        let borderColor: Color = isSelected ? .primary1 : Color("outline").opacity(0.4)
        let onContainerColor: Color = isSelected ? Color("onPrimary") : Color("onSurfaceVariant")

        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    isSelected
                        ? AnyShapeStyle(LinearGradient(
                            colors: [.primary1, Color("primaryContainer")],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        : AnyShapeStyle(Color("surfaceVariant"))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor, lineWidth: isSelected ? 2 : 1)
                )
                .animation(.spring(response: 0.25), value: isSelected)

            HStack(alignment: .center, spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(SongUtils.refineTitle(txt: book.title))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(isSelected ? onContainerColor : Color("onSurface"))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    SongCountChip(count: book.songs, isSelected: isSelected, textColor: onContainerColor)
                }
                Spacer(minLength: 0)
            }
            .padding(10)

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(onContainerColor)
                    .font(.system(size: 18))
                    .padding(8)
            }
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

private struct SongCountChip: View {
    let count: Int
    let isSelected: Bool
    let textColor: Color

    var body: some View {
        Text("\(count) Songs")
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(isSelected ? textColor : .primary1)
            .padding(.horizontal, 10)
            .padding(.vertical, 3)
            .background(
                Capsule().fill(
                    isSelected ? textColor.opacity(0.18) : Color.primary1.opacity(0.10)
                )
            )
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
