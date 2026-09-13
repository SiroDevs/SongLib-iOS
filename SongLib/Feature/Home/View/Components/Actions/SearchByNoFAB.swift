//
//  SearchByNoFAB.swift
//  SongLib
//
//  Created by Siro Daves on 12/09/2026.
//

import SwiftUI

struct SearchByNoFAB: View {
    let onClick: () -> Void
    var expanded: Bool = true

    var body: some View {
        Button(action: onClick) {
            HStack(spacing: 8) {
                Image(systemName: "circle.grid.3x3.fill")
                    .font(.title3.weight(.semibold))

                if expanded {
                    Text("Search by Number")
                        .font(.subheadline.weight(.semibold))
                        .lineLimit(1)
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
            }
            .foregroundColor(.onPrimaryContainer)
            .padding(.vertical, 14)
            .padding(.horizontal, expanded ? 18 : 14)
        }
        .background(Color.primaryContainer)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.18), radius: 6, x: 0, y: 4)
        .animation(.easeInOut(duration: 0.2), value: expanded)
    }
}

#Preview {
    VStack(spacing: 20) {
        SearchByNoFAB(onClick: {}, expanded: true)
        SearchByNoFAB(onClick: {}, expanded: false)
    }
    .padding()
}
