//
//  EmptyState.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import SwiftUI

struct EmptyState: View {
    var title: String = "Oops! It's empty here"
    var message: String? = nil
    var messageIcon: Image?
    var actionTitle: String? = "Retry"
    var action: (() -> Void)? = nil
    
    var titleColor: Color = .primary1
    var messageColor: Color = .secondary1
    var spacing: CGFloat = 20
    
    var body: some View {
        VStack(spacing: spacing) {
            
            Image(AppAssets.emptyIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .padding(.bottom, 5)
            
            Text(title)
                .font(.title)
                .foregroundColor(titleColor)
            
            if let message {
                Text(message)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(messageColor)
                    .padding(.horizontal)
            }
            
            if let messageIcon {
                messageIcon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(.vertical, 5)
            }
            
            if let action {
                Button(action: action) {
                    Text(actionTitle ?? "Retry")
                        .font(.title2)
                        .frame(width: 200)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.borderedProminent)
                .tint(.primary1)
                .padding(.horizontal)
            }
        }
        .padding()
    }
}

#Preview {
    EmptyState(
        message: "No songs were found.",
        messageIcon: Image(systemName: "heart.fill"),
        action: { print("Retry tapped") }
    )
}
