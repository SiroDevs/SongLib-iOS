//
//  ScrollToTopButton.swift
//  SongLib
//
//  Created by Siro Daves on 12/09/2026.
//

import SwiftUI

struct ScrollToTopButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.up")
                .font(.body.weight(.semibold))
                .foregroundColor(.onPrimaryContainer)
                .frame(width: 40, height: 40)
                .background(Color.primaryContainer)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    ScrollToTopButton {}
        .padding()
}
