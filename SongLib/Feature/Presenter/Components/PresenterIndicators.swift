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
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 10) {
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
        let bgColor = isSelected ? .primary1 : Color("onPrimary")
        let txtColor = isSelected ? Color("onPrimary") : .scrim

        Button(action: action) {
            Text(title)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(txtColor)
                .frame(width: 60, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10).fill(bgColor)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(bgColor, lineWidth: isSelected ? 0 : 2)
                )
                .animation(.easeInOut(duration: 0.2), value: isSelected)
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
        }
    }
}

#Preview{
    PresenterIndicators(
        indicators: ["1", "C", "2" ],
        selected: Page.first()
    )
}
