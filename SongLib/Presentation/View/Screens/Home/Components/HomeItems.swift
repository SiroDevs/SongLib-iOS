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
        .frame(height: 35)
    }
}

struct SongsSearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var onCancel: (() -> Void)?
    
    var body: some View {
        HStack(alignment: .center) {
            if isFocused {
                Button(action: {
                    text = ""
                    isFocused = false
                    hideKeyboard()
                    onCancel?()
                }) {
                    Image(systemName: "chevron.backward")
                        .font(.largeTitle)
                        .foregroundColor(.onPrimaryContainer)
                }
                .padding(.bottom, 5)
            }
            
            TextField("Search for songs ...", text: $text) .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 15)
                .padding(.top, 7)
                .focused($isFocused)
        }
        .padding(.horizontal)
        .animation(.easeInOut, value: isFocused)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
