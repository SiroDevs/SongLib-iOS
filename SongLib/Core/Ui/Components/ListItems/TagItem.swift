//
//  TagItem.swift
//  SongLib
//
//  Created by Siro Daves on 04/05/2025.
//

import SwiftUI

struct TagItem: View {
    let tagText: String
    let height: CGFloat

    var body: some View {
        if tagText.isEmpty {
            EmptyView()
        } else {
            Text(tagText)
                .font(.caption2)
                .italic()
                .foregroundColor(.onPrimary)
                .padding(.horizontal, 5)
                .padding(.vertical, 3)
                .background(.primary1)
                .cornerRadius(5)
        }
    }
}

#Preview{
    TagItem(tagText: "Tag", height: 50)
}
