//
//  SongNavZone.swift
//  SongLib
//
//  Created by Siro Daves on 11/09/2026.
//

import SwiftUI

/// A tappable corner of the verse card used to move to the previous/next
/// song. Android draws an animated page-curl there; this is a simpler
/// (but still tactile) equivalent - a curl image that dips and springs
/// back on tap. Drop your `curl_left`/`curl_right` artwork into
/// `Assets.xcassets/Presenter/` (stub image sets are already there - see
/// the project README note) and this lights up automatically.
struct SongNavZone: View {
    enum Corner {
        case leading, trailing
    }

    let corner: Corner
    let action: () -> Void

    @State private var isPressed = false

    private var imageName: String {
        corner == .leading ? "curl_left" : "curl_right"
    }

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 44, height: 44)
            .opacity(0.85)
            .scaleEffect(isPressed ? 0.82 : 1.0)
            .padding(10)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeOut(duration: 0.12)) { isPressed = true }
                action()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.14) {
                    withAnimation(.easeOut(duration: 0.16)) { isPressed = false }
                }
            }
    }
}
