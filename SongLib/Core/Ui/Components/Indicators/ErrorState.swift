//
//  ErrorState.swift
//  SongLib
//
//  Created by Siro Daves on 05/08/2025.
//

import SwiftUI

struct ErrorState: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)
                .foregroundColor(.red)

            Text("Oops!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.red)

            Text(message)
                .font(.title2)
                .multilineTextAlignment(.center)
                .foregroundColor(.onPrimary)
                .padding(.horizontal)

            Button(action: retryAction) {
                Text("Retry")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    ErrorState(
        message: "There was a problem. Please try again.",
        retryAction: { print("Retry tapped") }
    )
}
