//
//  PresenterIndicators.swift
//  SongLib
//
//  Created by Siro Daves on 07/05/2025.
//

import SwiftUI
import SwiftUIPager

struct PresenterIndicators: View {
    let indicators: [String]
    @ObservedObject var selected: Page
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 10) {
                ForEach(indicators.indices, id: \.self) { index in
                    IndicatorButton(
                        title: indicators[index],
                        isSelected: index == selected.index,
                        action: { selected.update(.new(index: index)) }
                    )
                }
            }
        }
        .padding(.horizontal)
    }
}

/// Circular verse/chorus badge, tapped to jump to that slide.
struct IndicatorButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    init(title: String, isSelected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        let bgColor = isSelected ? Color.primary1 : Color("onPrimary")
        let txtColor = isSelected ? Color("onPrimary") : .scrim

        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(txtColor)
                .frame(width: 44, height: 44)
                .background(Circle().fill(bgColor))
                .overlay(
                    Circle().stroke(Color("outline").opacity(0.3), lineWidth: isSelected ? 0 : 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
        }
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

#Preview{
    PresenterIndicators(
        indicators: ["1", "C", "2" ],
        selected: Page.first()
    )
}
