//
//  HomeSkeleton.swift
//  SongLib
//
//  Created by Siro Daves on 10/09/2026.
//

import SwiftUI

/// Placeholder for the whole Home screen, shown while `MainViewModel` is
/// still loading/syncing. Mirrors the real `HomeTabs` Search tab - same
/// title, same content layout - with everything replaced by shimmering
/// blocks. The tab bar itself stays hidden here (there's nothing to switch
/// between yet), and appears for the first time already fully formed once
/// `HomeTabs` takes over.
struct HomeSkeleton: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("surfaceVariant").opacity(0.3))
                        .frame(height: 44)
                        .shimmering()
                        .padding(.horizontal)

                    HStack(spacing: 10) {
                        ForEach(0..<4, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("surfaceVariant").opacity(0.3))
                                .frame(width: 72, height: 28)
                                .shimmering()
                        }
                        Spacer()
                    }
                    .padding(.horizontal)

                    VStack(spacing: 0) {
                        ForEach(0..<8, id: \.self) { index in
                            SongItemSkeleton()
                            if index < 7 {
                                Divider()
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(.surface)
            .navigationTitle("SongLib")
            .toolbarBackground(.regularMaterial, for: .navigationBar)
        }
    }
}

/// Mirrors the real `SongItem` layout: a leading accent bar, a stacked
/// title/subtitle, and a trailing heart placeholder.
private struct SongItemSkeleton: View {
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

#Preview {
    HomeSkeleton()
}
