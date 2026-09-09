//
//  BooksGridContent.swift
//  SongLib
//
//  Created by Siro Daves on 14/10/2025.
//

import SwiftUI

/// The book-selection grid + floating "Proceed" action.
/// Used by SelectionView while it's in the `.books` phase.
struct BooksGridContent: View {
    @ObservedObject var viewModel: SelectionViewModel
    @Binding var showAlertDialog: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
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
                    .padding(.bottom, 70)
                }

                Button(action: {
                    showAlertDialog = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark")
                        Text("Proceed")
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .foregroundColor(Color("onPrimary"))
                    .background(.primary1)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
                }
                .padding(16)
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
