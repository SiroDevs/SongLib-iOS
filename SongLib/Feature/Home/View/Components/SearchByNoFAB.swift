//
//  SearchByNo.swift
//  SongLib
//
//  Created by @sirodevs on 12/09/2026.
//

import SwiftUI

struct SearchByNoFAB: View {
    let onClick: () -> Void
    
    var expanded: Bool

    var body: some View {
        Button(action: onClick){
            HStack(spacing: expanded ? 8 : 0) {
                Image(systemName: "circle.grid.3x3.fill")
                    .font(.system(size: 20, weight: .semibold))

                if expanded {
                    Text("Search by Number")
                        .font(.system(size: 14, weight: .bold))
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                        .transition(.opacity.combined(with: .scale(scale: 0.8, anchor: .leading)))
                }
            }
            .foregroundColor(.white)
            .padding(.vertical, 14)
            .padding(.horizontal, expanded ? 20 : 14)
            .background(
                Capsule()
                    .fill(Color.primaryContainer)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: expanded)
    }
}
