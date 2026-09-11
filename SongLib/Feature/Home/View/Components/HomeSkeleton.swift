//
//  HomeSkeleton.swift
//  SongLib
//
//  Created by Siro Daves on 10/09/2026.
//

import SwiftUI

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

                    SongListSkeleton()
                }
                .padding(.vertical)
            }
            .background(.surface)
            .navigationTitle("SongLib")
            .toolbarBackground(.regularMaterial, for: .navigationBar)
        }
    }
}

#Preview {
    HomeSkeleton()
}
