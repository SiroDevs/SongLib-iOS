//
//  LoadingState.swift
//  SongLib
//
//  Created by Siro Daves on 04/08/2025.
//

import SwiftUI

struct LoadingState: View {
    var title: String = ""
    var showProgress: Bool = false
    var progressValue: Int = 0

    var body: some View {
        VStack(spacing: 20) {
            if !title.isEmpty {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.onPrimaryContainer)
                    .padding(.top, 12)
            }

            if showProgress {
                HStack {
                    ProgressView(value: Double(progressValue) / 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .onPrimary))
                        .frame(height: 20)
                    Spacer().frame(width: 8)
                    Text("\(progressValue) %")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.onPrimaryContainer)
                }
                .padding(.horizontal)
            }

            SongListSkeleton()
                .padding(.top, showProgress || !title.isEmpty ? 8 : 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.surface)
        .ignoresSafeArea()
    }
}

#Preview {
    LoadingState(title: "Fetching data ...")
}
