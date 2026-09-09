//
//  Shimmer.swift
//  SongLib
//
//  Created by Siro Daves on 04/09/2026.
//

import SwiftUI

/// A moving-gradient shimmer, matching Android's `ShimmerBrush` composable:
/// three surfaceVariant stops sweeping diagonally on an infinite loop.
struct Shimmer: ViewModifier {
    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [
                            Color("surfaceVariant").opacity(0.6),
                            Color("surfaceVariant").opacity(0.2),
                            Color("surfaceVariant").opacity(0.6)
                        ],
                        startPoint: .init(x: phase, y: phase),
                        endPoint: .init(x: phase + 1, y: phase + 1)
                    )
                    .frame(width: geo.size.width * 3, height: geo.size.height)
                }
            )
            .clipped()
            .onAppear {
                withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmering() -> some View {
        modifier(Shimmer())
    }
}
