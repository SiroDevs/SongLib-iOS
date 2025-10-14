//
//  Step1Content.swift
//  SongLib
//
//  Created by Siro Daves on 14/10/2025.
//

import SwiftUI

struct Step1Content: View {
    @ObservedObject var viewModel: SelectionViewModel
    @Binding var showAlertDialog: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {                
                ScrollView {
                    LazyVGrid(columns: columns(for: geometry.size.width), spacing: 10) {
                        ForEach(viewModel.books.indices, id: \.self) { index in
                            let selectable = viewModel.books[index]
                            SongBook(
                                book: selectable.data,
                                isSelected: selectable.isSelected
                            ) {
                                viewModel.toggleSelection(for: selectable.data)
                            }
                        }
                    }
                    .padding(10)
                }

                Button(action: {
                     showAlertDialog = true
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "checkmark")
                        Text("Proceed")
                    }
                    .frame(width: 150)
                    .padding()
                    .foregroundColor(.onPrimaryContainer)
                    .background(.primaryContainer)
                    .cornerRadius(10)
                }
            }
        }
    }
    
    private func columns(for width: CGFloat) -> [GridItem] {
        let itemWidth: CGFloat = 160
        let spacing: CGFloat = 16
        let availableWidth = width - 40
        
        let numberOfColumns = max(2, Int(availableWidth / (itemWidth + spacing)))
        return Array(repeating: GridItem(.flexible(), spacing: spacing), count: numberOfColumns)
    }
}

#Preview {
    Step1View()
}
