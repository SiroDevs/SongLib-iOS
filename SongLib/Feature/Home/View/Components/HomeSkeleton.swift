//
//  HomeSkeleton.swift
//  SongLib
//
//  Created by Siro Daves on 10/09/2026.
//

import SwiftUI

struct HomeSkeleton: View {
    var body: some View {
        TabView {
            searchSkeleton
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .background(.primaryContainer)

            Color.clear
                .tabItem {
                    Label("Likes", systemImage: "heart.fill")
                }
                .background(.primaryContainer)

            Color.clear
                .tabItem {
                    Label("Listings", systemImage: "list.number")
                }
                .background(.primaryContainer)

            Color.clear
                .tabItem {
                    Label("Drafts", systemImage: "doc.text")
                }
                .background(.primaryContainer)

            Color.clear
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .background(.primaryContainer)
        }
        .disabled(true)
    }

    private var searchSkeleton: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("surfaceVariant").opacity(0.3))
                        .frame(height: 40)
                        .shimmering()
                        .padding(.horizontal)

                    HStack(spacing: 10) {
                        ForEach(0..<4, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("surfaceVariant").opacity(0.3))
                                .frame(width: 72, height: 32)
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

private struct SongItemSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color("surfaceVariant").opacity(0.3))
                    .frame(width: 170, height: 18)
                    .shimmering()

                Spacer()

                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("surfaceVariant").opacity(0.3))
                    .frame(width: 40, height: 20)
                    .shimmering()
            }

            RoundedRectangle(cornerRadius: 4)
                .fill(Color("surfaceVariant").opacity(0.3))
                .frame(height: 14)
                .shimmering()

            RoundedRectangle(cornerRadius: 4)
                .fill(Color("surfaceVariant").opacity(0.3))
                .frame(width: 220, height: 14)
                .shimmering()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
    }
}

#Preview {
    HomeSkeleton()
}
