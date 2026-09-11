//
//  HomeItems.swift
//  SongLib
//
//  Created by Siro Daves on 19/08/2025.
//

import SwiftUI

struct BooksList: View {
    let books: [Book]
    let selectedBook: Int
    let onSelect: (Book) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack() {
                ForEach(Array(books.enumerated()), id: \.1.bookId) { index, book in
                    BookItem(
                        text: book.title,
                        isSelected: index == selectedBook,
                        onPressed: { onSelect(book) }
                    )
                }
            }
        }
        .padding(.leading, 5)
        .frame(height: 36)
    }
}

struct SongsSearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var onCancel: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 5) {
            HStack(spacing: 5) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color("onSurfaceVariant").opacity(0.6))

                TextField("Search songs …", text: $text)
                    .focused($isFocused)
                    .submitLabel(.search)

                if !text.isEmpty {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color("onSurfaceVariant").opacity(0.5))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 10)
            .background(Color("surfaceVariant").opacity(0.5))
            .cornerRadius(12)

            if isFocused {
                Button("Cancel") {
                    text = ""
                    isFocused = false
                    hideKeyboard()
                    onCancel?()
                }
                .font(.subheadline)
                .foregroundColor(.primary1)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .padding(.horizontal)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
