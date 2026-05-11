//
//  ChooseListingSheet.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import SwiftUI

struct ChooseListingSheet: View {
    let listings: [Listing]
    let onSelect: (Listing) -> Void
    let onNewList: (String) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var newListTitle = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    Button {
                        onNewList("New Song List")
                    } label: {
                        Label("New Song List", systemImage: "plus")
                            .foregroundColor(.primary1)
                    }
                    
                    ForEach(listings) { listing in
                        Button {
                            onSelect(listing)
                        } label: {
                            ListingItem(listing: listing)
                        }
                    }
                }
                
                Button("Done") {
                    dismiss()
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.primaryContainer)
                .foregroundColor(.onPrimaryContainer)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
            }
            .navigationTitle("Choose a List")
            .navigationBarTitleDisplayMode(.inline).toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary1)
                    }
                }
            }
        }
    }
}

#Preview {
    ChooseListingSheet(
        listings: Listing.sampleListings,
        onSelect: { listing in },
        onNewList: { title in }
    )
}
