//
//  SongNavZone.swift
//  SongLib
//
//  Created by Siro Daves on 11/09/2026.
//

import SwiftUI

struct SongNavZone: View {
    enum Corner {
        case leading, trailing
    }

    let corner: Corner
    let action: () -> Void

    @State private var isPressed = false

    private var imageName: String {
        corner == .leading ? "CurlLeft" : "CurlRight"
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
