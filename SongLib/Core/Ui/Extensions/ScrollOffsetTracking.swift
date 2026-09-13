//
//  ScrollOffsetTracking.swift
//  SongLib
//
//  Created by Siro Daves on 12/09/2026.
//

import SwiftUI

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    /// Reports this view's vertical offset within `coordinateSpace` - meant
    /// to be attached to a zero-height marker pinned to the very top of
    /// scrolling content (row or first VStack child), with the enclosing
    /// `ScrollView`/`List` given the matching `.coordinateSpace(name:)`.
    /// `onChange` fires with `0` at the top and increasingly negative
    /// values as the content scrolls up - handy for a "scroll to top"
    /// button or a FAB that collapses once scrolling starts.
    func trackScrollOffset(coordinateSpace: String, onChange: @escaping (CGFloat) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(
                        key: ScrollOffsetPreferenceKey.self,
                        value: proxy.frame(in: .named(coordinateSpace)).minY
                    )
            }
        )
        .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: onChange)
    }
}
