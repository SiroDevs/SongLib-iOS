//
//  HomeListings.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import SwiftUI

struct HomeListings: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var showNewListingAlert = false
    @State private var newListingTitle = ""

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.listings.isEmpty {
                    EmptyState(
                        message: L10n.emptyListing,
                        messageIcon: Image(systemName: "list.number")
                    )
                } else {
                    ListingsScrollView(listings: viewModel.listings)
                }
            }
            .navigationTitle("Song Listings")
            .toolbarBackground(.regularMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showNewListingAlert = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("New Listing", isPresented: $showNewListingAlert) {
                TextField("Listing title", text: $newListingTitle)
                Button("Add", action: {
                    guard !newListingTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    viewModel.saveListing(0, title: newListingTitle)
                    newListingTitle = ""
                })
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Enter a title for your new song listing")
            }
        }
    }
}

private struct ListingsScrollView: View {
    let listings: [Listing]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(listings.enumerated()), id: \.element.id) { index, listing in
                    VStack(spacing: 0) {
                        NavigationLink {
                            ListingView(listing: listing)
                        } label: {
                            ListingItem(listing: listing)
                        }

                        if index < listings.count - 1 {
                            Divider()
                        }
                    }
                }
            }
            .background(.surface)
            .padding(.vertical)
        }
    }
}
