//
//  HomeListings.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import SwiftUI
import RevenueCatUI

struct HomeListings: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var showNewListingAlert = false
    @State private var showPaywall = false
    @State private var showProLimit = false
    @State private var newListingTitle = ""

    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.isProUser && viewModel.listings.count >= 1 {
                    upgradeBanner
                }
                
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
            }
            .navigationTitle("Song Listings")
            .toolbarBackground(.regularMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        checkAndHandleNewListing()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .homeToolbar(viewModel: viewModel)
            .alert("New Listing", isPresented: $showNewListingAlert) {
                newListingAlertContent
            } message: {
                Text("Enter a title for your new song listing")
            }
            .alert("Support us by upgrading", isPresented: $showProLimit) {
                Button("Not Now", role: .cancel) {}
                Button("Upgrade") {
                    showPaywall = true
                }
            } message: {
                Text("Please purchase a subscription if you want to continue using this feature and all other Pro features.")
            }
            .sheet(isPresented: $showPaywall) {
            #if !DEBUG
            PaywallView(displayCloseButton: true)
            #endif
            }
        }
    }
    
    private var upgradeBanner: some View {
        VStack {
            HStack {
                Image(systemName: "crown.fill")
                    .foregroundColor(.yellow)
                Text("You are currently limited to only 1 listing")
                    .font(.caption)
                Spacer()
                Button("Upgrade to PRO") {
                    showPaywall = true
                }
                .font(.caption)
                .buttonStyle(.borderedProminent)
            }
            .padding(5)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
            .padding(.horizontal)
        }
    }
    
    private func checkAndHandleNewListing() {
        if !viewModel.isProUser && viewModel.listings.count >= 1 {
            showProLimit = true
        } else {
            showNewListingAlert = true
        }
    }
    
    private var newListingAlertContent: some View {
        Group {
            TextField("Listing title", text: $newListingTitle)
            Button("Add") {
                guard !newListingTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                viewModel.saveListing(0, title: newListingTitle)
                newListingTitle = ""
            }
            Button("Cancel", role: .cancel) {}
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
