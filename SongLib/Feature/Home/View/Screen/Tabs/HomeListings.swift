//
//  HomeListings.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import SwiftUI
import RevenueCatUI

struct HomeListings: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var showNewListingAlert = false
    @State private var showPaywall = false
    @State private var showProLimit = false
    @State private var newListingTitle = ""

    @State private var editMode: EditMode = .inactive
    @State private var selectedIDs: Set<Int> = []
    @State private var showDeleteConfirm = false

    private var isEditing: Bool { editMode == .active }

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
                        ListingsScrollView(
                            listings: viewModel.listings,
                            editMode: $editMode,
                            selectedIDs: $selectedIDs,
                            onDelete: { id in viewModel.deleteListing(id) }
                        )
                    }
                }
            }
            .navigationTitle(isEditing ? "\(selectedIDs.count) selected" : "Song Listings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.regularMaterial, for: .navigationBar)
            .toolbar {
                if !viewModel.listings.isEmpty {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(isEditing ? "Done" : "Edit") {
                            withAnimation {
                                editMode = isEditing ? .inactive : .active
                                if !isEditing {
                                    selectedIDs.removeAll()
                                }
                            }
                        }
                    }
                }
                if !isEditing {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            checkAndHandleNewListing()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                if isEditing {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button(role: .destructive) {
                            showDeleteConfirm = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .disabled(selectedIDs.isEmpty)

                        Spacer()

                        Button {
                            selectedIDs.removeAll()
                        } label: {
                            Label("Clear", systemImage: "xmark.circle")
                        }
                        .disabled(selectedIDs.isEmpty)
                    }
                }
            }
            .homeToolbar(viewModel: viewModel, actions: isEditing ? [] : .more)
            .toolbar(isEditing ? .hidden : .visible, for: .tabBar)
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
            .alert("Delete \(selectedIDs.count) \(selectedIDs.count == 1 ? "listing" : "listings")?", isPresented: $showDeleteConfirm) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    viewModel.deleteListings(selectedIDs)
                    selectedIDs.removeAll()
                }
            } message: {
                Text("This can't be undone.")
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


struct HomeListingsMock: View {
    @State private var showNewListingAlert = false
    @State private var newListingTitle = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(Listing.sampleListings.indices, id: \.self) { index in
                    let listing = Listing.sampleListings[index]

                    VStack(spacing: 0) {
                        NavigationLink {
                            ListingView(listing: listing)
                        } label: {
                            ListingItem(listing: listing)
                        }

                        if index < Listing.sampleListings.count - 1 {
                            Divider()
                        }
                    }
                }
                .background(.surface)
                .padding(.vertical)
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
                    newListingTitle = ""
                })
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Enter a title for your new song listing")
            }
        }
    }
}
