//
//  SongItemSkeleton.swift
//  SongLib
//
//  Created by Siro Daves on 11/09/2026.
//

import SwiftUI

/// Mirrors the real `SongItem` layout: a leading accent bar, a stacked
/// title/subtitle, and a trailing heart placeholder. Shared by every
/// screen-level skeleton that lists songs (`HomeSkeleton`, `ListingSkeleton`),
/// so a loading song list always shimmers the same way.
struct SongItemSkeleton: View {
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color("surfaceVariant").opacity(0.3))
                .frame(width: 3, height: 36)
                .shimmering()

            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color("surfaceVariant").opacity(0.3))
                    .frame(width: 170, height: 14)
                    .shimmering()

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color("surfaceVariant").opacity(0.3))
                    .frame(width: 110, height: 11)
                    .shimmering()
            }

            Spacer(minLength: 8)

            Circle()
                .fill(Color("surfaceVariant").opacity(0.3))
                .frame(width: 16, height: 16)
                .shimmering()
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
    }
}

/// A column of shimmering song rows, optionally divided - the shared body
/// of any "loading a list of songs" skeleton.
struct SongListSkeleton: View {
    var rowCount: Int = 8
    var showDividers: Bool = true

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<rowCount, id: \.self) { index in
                SongItemSkeleton()
                if showDividers && index < rowCount - 1 {
                    Divider()
                }
            }
        }
    }
}

#Preview {
    SongListSkeleton()
}
