//
//  SelectionSkeleton.swift
//  SongLib
//
//  Created by Siro Daves on 04/09/2026.
//

import SwiftUI

struct SelectionSkeleton: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: columns(for: geometry.size.width), spacing: 10) {
                    ForEach(0..<20, id: \.self) { _ in
                        SongBookSkeletonCard()
                    }
                }
                .padding(10)
            }
        }
        .background(.surface)
    }

    private func columns(for width: CGFloat) -> [GridItem] {
        let itemWidth: CGFloat = 160
        let spacing: CGFloat = 16
        let availableWidth = width - 40

        let numberOfColumns = max(2, Int(availableWidth / (itemWidth + spacing)))
        return Array(repeating: GridItem(.flexible(), spacing: spacing), count: numberOfColumns)
    }
}

private struct SongBookSkeletonCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color("surfaceVariant").opacity(0.3))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("outline").opacity(0.4), lineWidth: 1)
            )
            .overlay(
                VStack(alignment: .leading, spacing: 6) {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 90, height: 16)
                        .shimmering()
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 60, height: 14)
                        .shimmering()
                    Spacer()
                }
                .padding(12),
                alignment: .topLeading
            )
            .frame(height: 84)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    SelectionSkeleton()
}
